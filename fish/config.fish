if status is-interactive
    fish_default_key_bindings
    set -gx EDITOR nvim
    set -gx BROWSER zen-browser
    set -gx PATH $HOME/.local/bin $PATH
    stty erase "$(printf '\b')"
    set -gx PATH $HOME/.cargo/bin $PATH
    # Commands to run in interactive sessions can go here
end

fzf --fish | source

# === Enhanced CLI utils ===
alias ls="lsd -A --group-dirs=first"
alias ll="lsd -lA --group-dirs=first"
alias la="lsd -la --group-dirs=first"
alias cat="bat"
alias find="fd"
alias grep="rg"
alias tree="lsd --tree"
alias please="sudo"
zoxide init fish | source
alias nano="micro"
alias v="fd --type f --hidden --exclude .git | fzf --reverse --height=40% --border | xargs -r nvim"
alias opencsproj="cd ~/Dropbox/c\#projects/ && fd --type d --max-depth 1 --exclude . | fzf --reverse --height=40% --border \
  | xargs -I{} sh -c 'fd --type f --hidden --exclude .git --exclude bin --exclude obj . "{}" \
  | fzf --reverse --height=40% --border | xargs -r nvim'"
alias nvconf="cd ~/.config/nvim && nvim"
alias fishconf="cd ~/.config/fish/ && nvim ~/.config/fish/config.fish"
alias kittyconf="cd ~/.config/kitty && nvim ~/.config/kitty/kitty.conf"
alias hyprconf="cd ~/.config/hypr && nvim"
alias waybarconf="cd ~/.config/waybar && nvim ~/.config/waybar/config.jsonc"

alias save-audio='yt-dlp -x --audio-format mp3 -o "~/Music/%(title)s.%(ext)s"'
alias save-video='yt-dlp -f mp4 -o "~/Videos/%(title)s.%(ext)s"'

starship init fish | source

# binds
bind -e ctrl-t
bind -e -M insert ctrl-t

bind ctrl-t ''
bind -M insert ctrl-t ''

function fish_greeting
    fastfetch --config ~/.config/fastfetch/greeting.jsonc
end

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions --query __zoxide_cd_internal
    string replace --regex -- '^function cd\s' 'function __zoxide_cd_internal ' <$__fish_data_dir/functions/cd.fish | source
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    if set -q __zoxide_loop
        builtin echo "zoxide: infinite loop detected"
        builtin echo "Avoid aliasing `cd` to `z` directly, use `zoxide init --cmd=cd fish` instead"
        return 1
    end
    __zoxide_loop=1 __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (builtin count $argv)
    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if test $argc -eq 2 -a $argv[1] = --
        __zoxide_cd -- $argv[2]
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions.
function __zoxide_z_complete
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (command zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and __zoxide_cd $result
        and builtin commandline --function cancel-commandline repaint
    end
end
complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end
