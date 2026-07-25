set fish_greeting ""
set -gx EDITOR nvim
set -g nvm_default_version 22

set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

alias ls "ls -p -G"
alias la "ls -A"
alias lla "ll -a"
alias g git
if type -q eza
    alias ll "eza -l -g --icons"
end
if type -q nvim
    alias vim nvim
end

if type -q fzf_configure_bindings
    fzf_configure_bindings --directory=\cf --variables=\e\cv
end

if test -d "$HOME/.bun/bin"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path --global "$BUN_INSTALL/bin"
end

if status is-interactive
    if type -q starship
        starship init fish | source
    end

    if type -q fastfetch
        fastfetch
    end
end
