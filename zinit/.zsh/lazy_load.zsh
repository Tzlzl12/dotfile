# # --- pio lazy load ---
# alias pio='__lazyload_pio "$@"'
# __lazyload_pio() {
#   unalias pio
#   eval "$(_PIO_COMPLETE=zsh_source pio)"
#   command pio "$@"
# }
# --- pio 懒加载改进 ---
unalias pio 2>/dev/null
pio() {
    # 立即移除函数自身，恢复为真正的命令
    unfunction pio
    
    # 执行初始化
    if command -v pio >/dev/null 2>&1; then
        eval "$(_PIO_COMPLETE=zsh_source pio)"
    fi
    
    # 以后所有的调用都会直接指向真正的 pio 路径，不再走这个函数
    command pio "$@"
}

# # --- bun lazy load ---
# alias bun='__lazyload_bun "$@"'
# __lazyload_bun() {
#   unalias bun
#   [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
#   command bun "$@"
# }

# --- bun 懒加载改进 ---
unalias bun 2>/dev/null
bun() {
    unfunction bun
    
    local BUN_COMPLETION="$HOME/.bun/_bun"
    if [[ -s "$BUN_COMPLETION" ]]; then
        source "$BUN_COMPLETION"
    fi
    
    command bun "$@"
}
