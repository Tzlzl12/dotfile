function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

if status is-interactive
  starship init fish | source
  zoxide init fish | source
  # Set up fzf key bindings 
  fzf --fish | source

  fish_vi_key_bindings

  set -x PATH /home/tll/.local/bin \
              /home/tll/.local/share/nvim/mason/bin \
              /home/tll/.bun/bin \
              /home/tll/.cargo/bin \
              /home/tll/.platformio/packages/toolchain-gccarmnoneeabi/bin \
              $PATH

  # export PATH=/home/tll/tools/arm-gnu-toolchain/bin/:$PATH
# export QEMU_LD_PREFIX=/usr/riscv64-linux-gnu:$QEMU_LD_PREFIX
# export QEMU_LD_PREFIX=/home/tll/tools/riscv/sysroot
  source ~/.config/fish/alias.fish
  source ~/.config/fish/variables.fish

    # Commands to run in interactive sessions can go here
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
