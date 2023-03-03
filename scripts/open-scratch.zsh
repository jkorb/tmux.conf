#!/usr/bin/env zsh

session_name="$(tmux display-message -p "#S")"

if [[ $session_name == 'home' ]]; then
  session_dir="$HOME"
else
  session_dir="$HOME/$session_name"
fi

scratch_file="$session_dir/.scratch.md"

if [[ ! -f "$scratch_file" ]]; then
  touch "$scratch_file"
fi

tmux split-window -v "tmux split-window -h \"nvim $scratch_file\""
