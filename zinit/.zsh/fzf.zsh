# fzf 配置 - 使用 fd 查找文件
export FZF_DEFAULT_OPTS="--height 60% --reverse --border --prompt 'Search> '"

# 使用 fd 查找文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
