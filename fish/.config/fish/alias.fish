alias display='ln -s /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/'
alias cls=clear
alias ls='eza --icons=auto -F --group-directories-first'
alias tree='ls -T'
# alias rv32='riscv32-unknown-linux-gnu-gcc -march=rv32g -mabi=ilp32d'
alias tftp-start='sudo systemctl start tftpd.service'
alias tftp-stop='sudo systemctl stop tftpd.service'
alias llvm-file='llvm-objdump -f'
alias espexport='. ~/tools/esp/v5.2.3/esp-idf/export.fish'
alias fzfbat='fzf --preview "bat --color=always --style=numbers --line-range=:50
# alias man=tldr
0 {}"'
alias usbipd=usbipd.exe
alias usbshare='usbipd bind --busid '
alias usbattach='usbipd attach --wsl --busid '
alias usbdetach='usbipd detach --busid '

abbr --erase cd &>/dev/null
alias cd=__zoxide_z

abbr --erase cdi &>/dev/null
alias cdi=__zoxide_zi


