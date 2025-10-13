# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000

# -------alias--------- #
source ~/.zsh/alias.zsh
source ~/.zsh/zoxide.zsh
source ~/.zsh/export.zsh
source ~/.zsh/api_key.zsh

# export MESA_LOADER_DRIVER_OVERRIDE=nouveau_dri

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.plugin.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
# source ~/.zsh/zsh-completion/zsh-completions.plugin.zsh
# source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# # abbr --erase cd &>/dev/null
# alias cd=__zoxide_z
#
# # abbr --erase cdi &>/dev/null
# alias cdi=__zoxide_zi
# 终端Tab输入忽略大小写
# autoload -Uz compinit && compinit
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

autoload -U compinit; compinit



# eval "$(fnm env --use-on-cd)"
# End of lines configured by zsh-newuser-install


# Begin: PlatformIO Core completion support
eval "$(_PIO_COMPLETE=zsh_source pio)"
# End: PlatformIO Core completion support


# bun completions
[ -s "/home/tll/.bun/_bun" ] && source "/home/tll/.bun/_bun"
# >>> xmake >>>
test -f "/home/tll/.xmake/profile" && source "/home/tll/.xmake/profile"
# <<< xmake <<<
