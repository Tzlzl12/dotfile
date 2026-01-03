# --- 1. Tmux 自动启动 (安全模式) ---
# 去掉 exec，如果 tmux 启动失败，你会停留在 zsh 而不是关闭终端
if [[ -z "$TMUX" && -n "$PS1" && -x "$(command -v tmux)" ]]; then
    tmux attach-session -t default 2>/dev/null || tmux new-session -s default
fi

# --- 2. Zinit 基础 ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- 3. 补全系统专项修复 (WSL 提速关键) ---
# 告诉 Zinit 不要插手补全初始化
zicompinit_skip=1 

autoload -Uz compinit
# 强制使用 -C 模式：不检查安全，不扫描新补全，只读缓存。
# 只有这样才能保证你在 WSL 里的启动速度。
compinit -C

# --- 4. 插件加载 (使用 light 模式，最快且不产生监控) ---
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# --- 5. 核心工具 ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- 6. 延迟加载自定义配置 ---
# --- 6. 核心配置：直接加载 (总计 ~50ms，不卡) ---
load_core_configs() {
    # 按照依赖顺序加载
    local core_files=(
        ~/.zsh/export.zsh
        ~/.zsh/alias.zsh
        ~/.zsh/fzf.zsh
        ~/.zsh/api_key.zsh
        ~/.zsh/lazy_load.zsh
        ~/.zsh/zoxide.zsh
    )
    for f in $core_files; do
        [[ -f "$f" ]] && source "$f"
    done
}
load_core_configs  # 立即执行，确保 kk 瞬间可用

# --- 7. 沉重配置：延迟加载 (xmake 等) ---
load_heavy_stuff() {
    [[ -f ~/.xmake/profile ]] && source ~/.xmake/profile
    add-zsh-hook -d precmd load_heavy_stuff
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd load_heavy_stuff

# --- 7. 其他静态变量 ---
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000
export UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"

# FZF-Tab 样式
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# --- 历史记录搜索增强 ---

# 加载 Zsh 内置的搜索模块
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

# 定义搜索函数
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# 绑定到物理键盘的上下箭头
# [注]：某些终端环境下箭头键的转义码不同，这里覆盖了常见的两种模式
bindkey '^[[A' up-line-or-beginning-search   # 方向上键
bindkey '^[[B' down-line-or-beginning-search # 方向下键

# 针对 Tmux/某些终端补充绑定 (Keypad 模式)
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
