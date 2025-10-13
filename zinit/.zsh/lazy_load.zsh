# --- pio lazy load ---
alias pio='__lazyload_pio "$@"'
__lazyload_pio() {
  unalias pio
  eval "$(_PIO_COMPLETE=zsh_source pio)"
  command pio "$@"
}


# --- bun lazy load ---
alias bun='__lazyload_bun "$@"'
__lazyload_bun() {
  unalias bun
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  command bun "$@"
}

