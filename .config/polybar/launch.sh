#!/usr/bin/env sh

# Terminate already running bar instances
killall -q -s SIGKILL polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Check for arguments
if [[ "$#" -gt 0 ]]; then
    _polybar_config_file="$HOME/.config/polybar/config"
    # Launch bars
    if [[ ! "$#" -gt 1 ]]; then
        polybar --log=error "$1" &
    else
        for _bar in "$@"; do
            # Check if the bar exists so we can raise an error
            _bar_exists=$(cat "$_polybar_config_file" | grep "\[bar\/$_bar\]")
            if [[ -z "$_bar_exists" ]]; then
                echo >&2 -e "$(date +"%Y-%m-%d %H:%M:%S") [\033[1;31mERROR\033[0m] $_bar bar doesn't exists."
                exit 1
            else
                polybar --log=error "$_bar" &
                echo -e "$(date +"%Y-%m-%d %H:%M:%S") [\033[1;32mSUCCESS\033[0m] $_bar bar launched"
            fi
            sleep 1
        done
    fi
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") [\033[1;32mSUCCESS\033[0m] All bars launched"
else
    echo >&2 -e "$(date +"%Y-%m-%d %H:%M:%S") [\033[1;31mERROR\033[0m] You should provide at least one bar name to be launched"
    exit 1
fi
