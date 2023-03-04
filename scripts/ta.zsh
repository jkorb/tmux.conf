#!/bin/zsh

# Functions

has_session_running() {
  tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"
}

has_session_stored() {
  ls -a "$dir" | grep -q ".tmuxp.yaml"  
}

load_session() {
  tmuxp load -d "$dir"
}

in_tmux() {
  [ -n "$TMUX" ]
}

store_session() {
  tmuxp freeze -y -q -f yaml -o $dir/.tmuxp.yaml
}

create_session() {
  
 if has_session_stored; then
   load_session
 else
   (TMUX='' tmux new-session -Ad -c "$dir" -e TMUX_SESSION_HOME="$dir" -s "$session_name")
 fi

 # [[ ! -f "$dir"/.scratch.md ]] && touch "$dir"/.scratch.md

}

sanitize_session_name() {

  local inp
  local tmp
  local out

  inp="$1"

  tmp="$inp"

  # remplace spaces and dots
  tmp="$(echo $tmp | tr ' ' _ | tr '.' _ )"

  # remove $HOME 
  tmp="$(echo $tmp | sed 's/\/home\/jkorbmacher\///')"

  out="$tmp"

  echo "$out"

}

#Variables

dir="$PWD"

if [[ $# -gt 0 ]]; then
  case $1 in 
    remote) 
      if [[ -z "$2" ]]; then
        # do nothing
        : 
      elif [[ -d "$2" ]]; then
        dir="$2"
      else
        >&2 echo "Error: argument not a directory" 
        exit 1
      fi
      ;;
    *)
      >&2 echo "Error: unknown command"
      exit 1
      ;;
  esac
fi

if [[ "$dir" == "$HOME" ]]; then
  session_name="home"
else
  session_name="$(sanitize_session_name "$dir")"
fi

if in_tmux; then
  cmd="switch-client -t"
else
  cmd="new-session -As "
fi

# Main logic

if ! has_session_running; then
  create_session
fi

eval "tmux $cmd \"$session_name\""
