## prepapre
```bash
setfont ter-132n
# test
ping -c 5 archlinux.org
# wifi 
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
greetd-regreet greetd
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
