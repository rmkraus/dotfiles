#!/bin/bash
_=$(which tmux)
TMUX_FOUND=$?
_=$(env | grep -i tmux)
INTMUX=$?

if [[ $TMUX_FOUND -eq 0 && $INTMUX -eq 1 ]]; then
    tmux new /usr/local/bin/docker exec -it workspace /bin/bash
else
    /usr/local/bin/docker exec -it workspace /bin/bash
fi
