#!/usr/bin/env zsh

session_name="$(tmux display-message -p "#S")"

if [[ $session_name == 'home' ]]; then
  session_dir="$HOME"
else
  session_dir="$TMUX_SESSION_HOME"
fi

tmux new-window -c "$session_dir"
