# fzf 配置 - 使用 fd 查找文件
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --prompt 'Search> ' --preview 'bat --style=numbers --color=always --line-range :100 {}' --preview-window=up:1:wrap"

# 使用 fd 查找文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# 纯补全 PID，用在 kill -9 <Tab> 这种场景
_fzf_complete_kill() {
    local cur prev
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if [[ $prev == -* ]]; then
        COMPREPLY=($(compgen -W "-9 -15 -TERM -KILL" -- "$cur"))
    else
        local pids
        pids=$(ps -u "$USER" -o pid= -o comm= | \
               fzf --multi --exit-0 --query "$cur" --select-1 --print-query | \
               tail -n +2 | awk '{print $1}')
        COMPREPLY=($pids)
    fi
}

complete -F _fzf_complete_kill -o nospace kill
