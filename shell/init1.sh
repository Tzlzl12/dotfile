echo 'set root password'
passwd 

echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
useradd -m -G wheel -s /bin/bash tll
echo 'set user password'
passwd tll

sudo pacman-key --init 
sudo pacman-key --populate 
curl -l -O "https://raw.githubusercontent.com/LS-KR/Arch-Install-Shell-Stable/main/ustc-mirror.sh"
sudo sh ./ustc-mirror.sh 
sudo pacman -Syyu

ehco 'add next content'
# sudo echo '[archlinuxcn]' >> /etc/pacman.conf
# sudo echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
# sudo pacman -Syy
# sudo pacman -S --noconfirm archlinuxcn-keyring
# sudo pacman -S yay
