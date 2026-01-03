alias display='sudo ln -s /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/'
alias ta='tmux attach-session'
alias autoremove='zypper rm --clean-deps'
alias fastfetch=macchina
alias cls=clear
alias hx=helix
alias trans-zh='trans zh-CN:en'
alias procs='procs $USER'
alias ls='eza --icons=auto -F --group-directories-first'
alias tree='ls -T'
alias rv32='riscv32-unknown-linux-gnu-gcc -march=rv32g -mabi=ilp32d'
alias tftp-start='sudo systemctl start tftpd.service'
alias tftp-stop='sudo systemctl stop tftpd.service'
alias llvm-file='llvm-objdump -f'
alias usb=usbipd.exe
alias usbbind='usbipd.exe bind --busid '
alias usbattach='usbipd.exe attach --wsl --busid '
alias zypper='ZYPP_PCK_PRELOAD=1 ZYPP_CURL2=1 zypper'
# alias man=tldr
alias fzfbat='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias neovide='neovide.exe --wsl'
