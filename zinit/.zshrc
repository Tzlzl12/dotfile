# --- 0. 性能剖析启动 (可选，调试完可注释掉) ---
# zmodload zsh/zprof

# --- 1. Tmux 自动启动逻辑 ---
# 必须放在最前面：如果在交互式 Shell 且不在 Tmux 中，则自动进入
if [[ -z "$TMUX" && -n "$PS1" ]]; then
    if command -v tmux >/dev/null 2>&1; then
        # 不使用 exec，给 Zsh 留条后路
        tmux attach-session -t default 2>/dev/null || tmux new-session -s default
    fi
fi

# --- 2. Zinit 基础环境 ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- 3. 插件异步加载 (性能关键) ---
# wait"1" 表示进入提示符 1 秒后再加载，lucid 隐藏加载信息
zinit wait"1" lucid for \
    atinit"zicompinit; zicdreplay" \
    Aloxaf/fzf-tab \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting

# --- 4. 核心工具初始化 ---
# Starship 和 Zoxide 经过优化，直接初始化即可
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- 5. 延迟加载自定义配置 (Alias/Export) ---
autoload -Uz add-zsh-hook
load_extra_configs() {
    if [[ -z "$_EXTRA_CONFIGS_LOADED" ]]; then
        # 批量加载你的模块化文件
        [[ -f ~/.zsh/alias.zsh ]]     && source ~/.zsh/alias.zsh
        [[ -f ~/.zsh/zoxide.zsh ]]    && source ~/.zsh/zoxide.zsh
        [[ -f ~/.zsh/export.zsh ]]    && source ~/.zsh/export.zsh
        [[ -f ~/.zsh/api_key.zsh ]]   && source ~/.zsh/api_key.zsh
        [[ -f ~/.zsh/lazy_load.zsh ]] && source ~/.zsh/lazy_load.zsh
        [[ -f ~/.zsh/dotnet.zsh ]]    && source ~/.zsh/dotnet.zsh
        [[ -f ~/.xmake/profile ]]     && source ~/.xmake/profile

        _EXTRA_CONFIGS_LOADED=1
        add-zsh-hook -d precmd load_extra_configs
    fi
}
add-zsh-hook precmd load_extra_configs

# --- 6. 补全系统优化 (使用缓存防止扫描导致卡顿) ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi

# --- 7. 静态变量与路径 ---
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000
export UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"
fpath+=~/.zsh/zfunc

# --- 8. 补全样式定制 ---
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a1 --icons=auto --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# 结束性能剖析 (配合开头)
# zprof
