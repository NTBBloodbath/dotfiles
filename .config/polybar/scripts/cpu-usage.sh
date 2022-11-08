#!/usr/bin/env sh

get_cpu_usage() {
    local usage=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{printf "%.0f\n", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')
    local percentage=$(( usage / 10 ))
    local percentage_bars="%{F#89b4fa}"
    if [ "$percentage" -eq 0 ]
    then
        percentage_bars+="%{F-}%{F#585b70}──────────"
    elif [ "$percentage" -eq 1 ]
    then
        percentage_bars+="─%{F-}%{F#585b70}─────────"
    else
        for ((i = 1 ; i <= 10 ; i++))
        do
            percentage_bars+="─"
            if [ "$i" = "$percentage" ]
            then
                percentage_bars+="%{F-}%{F#585b70}"
            fi
        done
    fi
    percentage_bars+="%{F-}"

    echo "%{F#89b4fa}%{F-} $percentage_bars"
}

get_cpu_usage
