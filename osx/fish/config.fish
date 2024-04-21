set fish_greeting ""

set -gx EDITOR nvim

set -gx TERM screen-256color

# custom scripts
set -gx PATH $PATH /usr/local/bin/scripts
set -U fish_user_paths $fish_user_paths ~/.dotnet/tools
set -gx nvm_default_version latest

alias vim="nvim"

# theme
# TokyoNight Color Palette
set -l foreground c8d3f5
set -l selection 3654a7
set -l comment 7a88cf
set -l red ff757f
set -l orange ff966c
set -l yellow ffc777
set -l green c3e88d
set -l purple fca7ea
set -l cyan 86e1fc
set -l pink c099ff

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection



set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "exa -l -g --icons"
alias lla "ll -A"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        # Do nothing
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

function dotfiles
    if test (count $argv) -eq 2
        if test $argv[1] = nvim -a $argv[2] = update
            /usr/local/bin/scripts/dotfiles-nvim-update.fish
        else
            echo "Invalid arguments."
        end
    else
        echo "Invalid arguments."
    end
end

starship init fish | source
nvm use default # workaround for nvm bug
clear
neofetch
