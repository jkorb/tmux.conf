#!/usr/bin/env zsh

cmd="fd --ignore-file $XDG_DATA_HOME/fd/fdignore -L --strip-cwd-prefix --one-file-system -t d -p --base-directory $HOME ."
dir="$(eval "$cmd" | fzf-tmux --cycle --height=40% --preview 'tree -C $HOME/{} | head -200' --reverse --history=$XDG_CACHE_DIR/fzf/dir_history --history-size=1000000000)"
dir="$(echo "$dir" | sed 's/\/$//')"

if [[ -n "$dir" ]]; then
    ta remote "$HOME/$dir"
fi
