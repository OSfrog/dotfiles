set fish_greeting ""
set -gx EDITOR nvim
set -gx TERM screen-256color

if type -q security
    set -l node_auth_token (security find-generic-password -a $USER -s NODE_AUTH_TOKEN -w 2>/dev/null)
    if test -n "$node_auth_token"
        set -gx NODE_AUTH_TOKEN $node_auth_token
    end
end

for path in "$HOME/.local/bin" "$HOME/.dotnet/tools" /usr/local/bin/scripts
    if test -d "$path"
        fish_add_path --global "$path"
    end
end

alias vim="nvim"
alias ls "ls -p -G"
alias la "ls -A"
if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -A"
end

# TokyoNight color palette
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
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

function dotfiles
    if test (count $argv) -eq 2; and test $argv[1] = nvim; and test $argv[2] = update
        if type -q dotfiles-nvim-update.fish
            dotfiles-nvim-update.fish
        else
            echo "dotfiles-nvim-update.fish is not available on this machine."
        end
    else
        echo "Usage: dotfiles nvim update"
    end
end

set -l pnpm_home "$HOME/Library/pnpm"
if test -d "$pnpm_home"
    set -gx PNPM_HOME "$pnpm_home"
    fish_add_path --global "$PNPM_HOME"
end

if test -d "$HOME/.bun/bin"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path --global "$BUN_INSTALL/bin"
end

if test -d "$HOME/Library/Android/sdk"
    set -gx ANDROID_HOME "$HOME/Library/Android/sdk"
    for path in "$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools"
        if test -d "$path"
            fish_add_path --global "$path"
        end
    end
end

if test -d "$HOME/.antigravity/antigravity/bin"
    fish_add_path --global "$HOME/.antigravity/antigravity/bin"
end

if status is-interactive
    if type -q starship
        starship init fish | source
    end

    if type -q nvm
        set --erase nvm_current_version
        nvm use --silent default
    end
end
