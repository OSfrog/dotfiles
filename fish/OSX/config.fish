set fish_greeting ""

set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx PATH /opt/homebrew/bin $PATH
set -Ux nvm_default_version 18
set -x XDG_CONFIG_HOME "$HOME/.config"

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "exa -l -g --icons"
alias lla "ll -a"
alias g git
alias cat bat
command -qv nvim && alias vim nvim

# fzf bind Search Directory to Ctrl+F and Search Variables to Ctrl+Alt+V
fzf_configure_bindings --directory=\cf --variables=\e\cv


if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
