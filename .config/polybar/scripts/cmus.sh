#!/bin/bash

icon_color=#282c34
duration_color="$icon_color"

output=$(cmus-remote -C status)
artist=$(echo "$output" | grep "^tag artist" | cut -c 12-)
path=$(echo "$output" | grep "^file" | cut -c 12-)
cmus_status=$(echo "$output"| grep "^status" | cut -c 8-)
case "$cmus_status" in 
    "playing")
        icon=" "
        ;;
    "paused")
        icon=" "
        ;;
    "stopped")
        icon=" "
        ;;
    *)
        icon=" "
        ;;
esac

if [[ $artist = *[!\ ]* ]]; then
    song=$(echo "$output" | grep "^tag title" | cut -c 11-)
    position=$(echo "$output" | grep "position" | awk '{ printf $2 }')
    duration=$(echo "$output" | grep "duration" | awk '{ printf $2 }')
    if [[ "$duration" -ge 0 ]]; then
        pos_minutes=$(printf "%02d" $((position / 60)))
        pos_seconds=$(printf "%02d" $((position % 60)))

        dur_minutes=$(printf "%02d" $((duration / 60)))
        dur_seconds=$(printf "%02d" $((duration % 60)))

        info_string="$pos_minutes:$pos_seconds / $dur_minutes:$dur_seconds"
    fi

    echo -n "%{F$icon_color}${icon}$artist - $song%{F-}" #  %{F$icon_color}%{F-} %{F$duration_color}$info_string%{F-}"
elif [[ $path = *[!\ ]* ]]; then
    IFS="/"
    read -ra parts <<< "$path"
    for i in "${parts[@]}"; do
        file=$i
    done
    position=$(echo "$output" | grep "position" | awk '{ printf $2 }')
    duration=$(echo "$output" | grep "duration" | awk '{ printf $2 }')
    if [[ "$duration" -ge 0 ]]; then
        pos_minutes=$(printf "%02d" $((position / 60)))
        pos_seconds=$(printf "%02d" $((position % 60)))

        dur_minutes=$(printf "%02d" $((duration / 60)))
        dur_seconds=$(printf "%02d" $((duration % 60)))

        info_string="$pos_minutes:$pos_seconds / $dur_minutes:$dur_seconds"
    fi

    echo -n "%{F$icon_color}${icon}$file%{F-}" # %{F$icon_color}-%{F-}" %{F$duration_color}$info_string%{F-}"
else
    echo "%{F$icon_color}${icon}Not playing%{F-}"
fi
