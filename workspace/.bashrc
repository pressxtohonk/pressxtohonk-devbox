alias cat='bat -p'
alias cd='z'
alias ll='ls -halp --color --group-directories-first'

# Enable colours in the terminal
export EDITOR="nvim"
export TERM="xterm-256color"

eval "$(direnv hook bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
