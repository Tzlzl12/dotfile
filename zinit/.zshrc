# zmodload zsh/zprof

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000

# Load powerlevel10k theme (commented out in original)
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# plugins 
zinit wait"1" lucid for \
  Aloxaf/fzf-tab \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting 

# 
autoload -Uz add-zsh-hook
load_export() {
  # 只加载一次
  if [[ -z "$_EXPORT_LOADED" ]]; then
    source ~/.zsh/alias.zsh
    source ~/.zsh/zoxide.zsh
    source ~/.zsh/export.zsh
    source ~/.zsh/api_key.zsh
    source ~/.zsh/lazy_load.zsh
    source ~/.zsh/dotnet.zsh
    test -f "/home/tll/.xmake/profile" && source "/home/tll/.xmake/profile"
    _EXPORT_LOADED=1
    add-zsh-hook -d precmd load_export  # 移除 hook
  fi
}
add-zsh-hook precmd load_export
# Completion configuration

# FZF-Tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a1 --icons=auto --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# Initialize starship and zoxide
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

fpath+=~/.zsh/zfunc
autoload -Uz compinit; compinit
# autoload -Uz compinit && compinit
sudo modprobe vhci-hcd 2>/dev/null || true
# zprof

# # >>> xmake >>>
# test -f "/home/tll/.xmake/profile" && source "/home/tll/.xmake/profile"
# # <<< xmake <<<
export UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"
