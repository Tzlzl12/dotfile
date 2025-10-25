## 手动
```bash
systemctl stop reflector.service 
rfkill unblock wifi 
iwctl 
&列出 网卡名【假设名为wlan0,需根据实际网卡名 替换下文 wlan0】
device list
&扫描网络 正常无输出 仅报错有输出
station wlan0 scan
&列出可用网络
station wlan0 get-networks
&指定wifi连接【回车后会让输入密码 连接完成】
station wlan0 connect <wifi实际名>
&退出连接模式
exit
# check 
ping archlinux.org -c 5
timedatectl 
# 换国内镜像源
vim /etc/pacman.d/mirrorlist 
sudo pacman -Sy
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate 
pacman -Sy archlinux-keyring

## 分区格盘
parted /dev/nvme0n1 
(parted) mktable
New disk label type? gpt
(parted) quit

lsblk
cfdisk /dev/nvme0n1
mkfs.fat -F32 /dev/sda1 
mkfs.ext4 /dev/sda2 
mkswap /dev/sda3

mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/nvme0n1p2

# check
df -h
free -h

pacstrap -K /mnt base base-devel  linux-firmware linux linux-headers intel-ucode amd-ucode
genfstab -U /mnt >> /mnt/etc/fstab 
# check 
cat /mnt/etc/fstab

arch-chroot /mnt

```
root@archiso ~ # arch-chroot /mnt before 
[root@archiso /] # arch-chroot /mnt after

```bash
pacman -S  vim networkmanager
systemctl enable  NetworkManager
passwd root
# boot loader 
pacman -S grub efibootmgr dosfstools mtools
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
显示"Installation finished. No error reperted" 是正常输出
vim /etc/default/grub 
去掉 GRUB_CMDLINE_LINUX_DEFAULT 一行中最后的 quiet 参数
把 loglevel 的数值从 3 改成 5。这样是为了后续如果出现系统错误，方便排错
加入 nowatchdog 参数，这可以显著提高开关机速度
仅双系统需要 取消此配置文件最后一行 GRUB_DISABLE_OS_PROBER=false 前面的# 号后再保存
grub-mkconfig -o /boot/grub/grub.cfg
exit              # 退回安装环境
umount -R /mnt    # 卸载新分区
reboot            # 重启

针对systemd-boot
bootctl install 
efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Arch Linux" -l '\EFI\systemd\systemd-bootx64.efi'
vim /boot/loader/loader.conf
default  arch.conf
timeout  4
console-mode max
editor   no
vim /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw 或者root=/dev/sda3 rw


nmtui
&通过以下命令添加用户，比如新增加的用户叫 fufumi
useradd -m -G wheel -s /bin/bash fufumi
&根据提示设置新用户 myusername 的密码
passwd  fufumi
&设置权限
sudo nano /etc/sudoers
找到如下这样的一行，把前面的注释符号 # 去掉：
#%wheel ALL=(ALL:ALL) ALL
```

## prepapre
```bash
setfont ter-132n
# for test
ping -c 5 archlinux.org
# 网络连接 
iwctl 
device list 
device wlan0 set-property Powered on
station wlan0 get-networks
station wlan0 connect xxx
exit

# pacman dont needed, config in the later
pacman -Syu 
pacman -S archlinux-keyring
```

## 问题
* pacman-keyring 
`systemctl show --no-pager -p SubState --value archlinux-keyring-wkd-sync.service` --dead 未完成
`systemctl show --property=ActiveEnterTimestamp --no-pager archlinux-keyring-wkd-sync.timer`
`/usr/bin/archlinux-keyring-wkd-sync`
```bash
killall gag-agent 
rm -rf /etc/pacman.d/gnupg 
pacman-key --init
pacman-key --populate 
pacman -Sy archlinux-keyring
systemctl restart archlinux-keyring-wkd-sync.timer
```
* 卡在time sync 
archinstall --skip-ntp # 在确定时间正确的前提下
```bash
sudo systemctl disable systemd-timesyncd.service
vim /etc/systemd/timesyncd.service 
[Time]
NTP=ntp.ntsc.ac.cn cn.ntp.org.cn
# ntp.tuna.tsinghua.edu.cn 
# ntp.aliyun.com
systemctl enable --now systemd-timesyncd
systemctl restart systemd-timesyncd.service

```
## 更新系统
`sudo pacman -Syu`
**更新时间**
``` bash
sudo timedatectl set-ntp true
```
**换国内镜像源**
/etc/pacman.d/mirrorlist
`Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch`

## 分区格盘
```bash
lsblk # 查看磁盘 
  # sda bootableUSB
  # nvme0n1 main derive
cfdisk /dev/sdx # 格式化磁盘
  new 1G type EFI
  new other type filesystem

mkfs.fat -F32 /dev/nvme0n1px # format EFI 
mkfs.ext4 /dev/nvme0n1py # format main


mount /dev/nvme0n1py /mnt 
mkdir /mnt/boot 
mount /dev/nvme0n1px /mnt/boot
lsblk # to check
```

## archinstall 
before `archinstall`
`systemctl mask reflector.service`
* mirrors and repositorise 
* disk config
  - pre-mounted configuration
    - Root mount directory - /mnt
* enable Swap
* Bootloader 
  - systemd-boot 
  - grub 
  - limine
* application
  - bluetooth
  - pipewire

* network (needed watch)
  - use network manager

* timezone
  - Asia/Shanghai

**Last**
press install 

**chroot into environment**
**configure grub** 
* grub
    * pacman -S grub efibootmgr dosfstools mtools
    * grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    * grub-mkconfig -o /boot/grub/grub.cfg
    * umount -lR /mnt
      | BIOS -OS BOOT Manager -> GRUB
    * add Windows to Grub
      1. sudo vim /etc/default/grub 
      TIMEOUT=5 -> 30 
      2. GRUB_DISABLE_OS_PROBER=false
      3. pacman -S os-prober
      4. grub-mkconfig -o /boot/grub/grub.cfg
      **Output: Found Windows on disk**
* Limine
    - install: pacman -S limine 
    - vim /boot/limine.cfg 
    | TIMEOUT=5
    | :Arch Linux 
    | KERNEL_PATH=boot:///vmlinuz-linux
    | MODULE_PATH=boot:///initramfs-linux.img
    | KERNEL_ARGS=root=/dev/sda2
    - limine bios-install /boot
* systemd-boot
    - bootctl install 
    - vim /boot/loader/loader.conf
        default arch
        timeout 3
        console-mode keep
        editor no
    - vim /boot/loader/entries/arch.conf
        title Arch Linux
        linux /vmlinuz-linux
        initrd /initramfs-linux.img
        options root=PARTUUID=你的根分区PARTUUID rw
    - `blkid -s PARTUUID -o value /dev/sdXY`
    - check `ls /boot/efi/EFI/systemd/ ls /boot/loader/entries/`
**after exit chroot env umount -R /mnt**

## Hyprland
```bash
pacman -S hyprland wayland wayland-protocols xorg-xwayland \
kitty git \
greetd-regreet greetd greetd-tuigreetd
# enable greetd 
sudo systemctl enable greetd 
# check 
sudo systemctl status greetd
cat /etc/systemd/system/display-manager.service # current display manager
# stop 
sudo systemctl stop greetd 
```

```bash
sudo pacman -S --needed git base-devel

`lmpala` tui for wifi
`bluetui` for bluetooth
`uwsm`
`walker`
`waybar`
`swayosd`
```

## 设置 
```bash
sudo pacman -S thunar-volman gvfs
systemctl enable udisks2.service

# 汉化
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation

/etc/locale.gen 
去掉 # en_US.UTF-8 UTF-8 以及 zh_CN.UTF-8 UTF-8 前#号后保存 
sudo locale-gen
su
 echo 'LANG=en_US.UTF-8'  > /etc/locale.conf
 echo 'LANG=zh_CN.UTF-8'  > /etc/locale.conf

reboot

sudo pacman -S  ttf-fira-code
## time 
su
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```
### 设置网络
```bash
********************设置网络*********************************

&设置自定义主机名 会体现在命令行【不要包含特殊字符以及空格】
nano /etc/hostname

&设置 host文件【Arch为刚设置的主机名 对于替换 可使用tab 分割】
nano /etc/hosts
加入
127.0.0.1   localhost
::1         localhost
127.0.1.1   Arch.localdomain    Arch

**************声音固件**************************
sudo pacman -S  --needed sof-firmware alsa-firmware alsa-ucm-conf pipewire-pulse pipewire-alsa wireplumber
```
### 输入法
```bash
*********************** 输入法*********************
sudo pacman -S fcitx5-im fcitx5-chinese-addons 

#配置输入法
mkdir ~/.config/environment.d/
nano ~/.config/environment.d/im.conf
#写入
#Wayland
XMODIFIERS=@im=fcitx
```
### 家目录
```bash 
**********************家目录*********************************************
#  安装 【可以不生成 重启就自动生成 当前语言的了】 
sudo pacman -S xdg-user-dirs

#运行生成中文的家目录
xdg-user-dirs-update
#或者生成英文的家目录
 LANG=en_US.UTF-8 xdg-user-dirs-update 
******************************************************************
在 /home/expo/.config/ user-dirs.dirs  可以修改路径
```
### 软件
```bash
yay -S clash-verge-rev-bin
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

sudo pacman -S safeeyes

yay -S gammastep
```
