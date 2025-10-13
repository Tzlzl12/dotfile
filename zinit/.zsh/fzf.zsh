# fzf 配置 - 使用 fd 查找文件
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --prompt 'Search> ' --preview 'bat --style=numbers --color=always --line-range :100 {}' --preview-window=up:1:wrap"

# 使用 fd 查找文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
