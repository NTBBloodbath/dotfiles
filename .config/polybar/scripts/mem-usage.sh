#!/usr/bin/env bash

get_mem_usage() {
    local usage="$(free | grep Mem | awk '{ printf("%.0f\n", $3/$2 * 100.0) }')"
    local percentage=$(( usage / 10 ))
    local percentage_bars="%{F#ecbe7b}"
    if [ "$percentage" -eq 0 ]
    then
        percentage_bars+="%{F-}%{F#5B6268}──────────"
    elif [ "$percentage" -eq 1 ]
    then
        percentage_bars+="─%{F-}%{F#5B6268}─────────"
    else
        for ((i = 1 ; i <= 10 ; i++))
        do
            percentage_bars+="─"
            if [ "$i" = "$percentage" ]
            then
                percentage_bars+="%{F-}%{F#5B6268}"
            fi
        done
    fi
    percentage_bars+="%{F-}"

    echo "%{F#ecbe7b}﬙%{F-} $percentage_bars"
}

get_mem_usage
