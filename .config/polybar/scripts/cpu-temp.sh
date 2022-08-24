#!/usr/bin/env sh

get_cpu_temp() {
    local average=0
    local temp_emotes=("" "" "" "" "")
    local temp_status="${temp_emotes[0]}"

    for temp in $(sensors | grep Core | awk '{print substr($3, 2, length($3)-5)}' | tr "\\n" " "); do
        average="$(( average + temp ))"
    done
    average="$(( average / $(nproc) ))"
 
	if [[ "$average" -gt 40 && "$average" -lt 65 ]]; then
		temp_status="${temp_emotes[1]}"
	elif [[ "$average" -lt 70 ]]; then
		temp_status="${temp_emotes[2]}"
	elif [[ "$average" -le 90 ]]; then
		temp_status="${temp_emotes[3]}"
	elif [[ "$average" -gt 90 ]]; then
		temp_status="${temp_emotes[4]}"
    fi
    average=$(echo "$average" | sed 's/$/°C/g')

    echo "%{F#ff6c6b}$temp_status%{F-} $average"
}

get_cpu_temp
