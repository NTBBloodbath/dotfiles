#!/usr/bin/env bash

# finds the active sink for pulseaudio and increments the volume. useful when you have multiple audio outputs and have a key bound to vol-up and down

osd='no'
inc='5'
capvol='no'
maxvol='100'
autosync='yes'

# Muted status
# yes : muted
# no : not muted
curStatus="no"
active_sink="alsa_output.pci-0000_00_1b.0.analog-stereo"
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

reloadSink() {
    active_sink='alsa_output.pci-0000_00_1b.0.analog-stereo'
}

function volUp {

    getCurVol

    if [ "$capvol" = 'yes' ]
    then
        if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- 100%
        elif [ "$curVol" -lt "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- "+$inc%"
        fi
    elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "$maxvol%"
    elif [ "$curVol" -lt "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "+$inc%"
    fi

    getCurVol

    if [ ${osd} = 'yes' ]
    then
        qdbus-qt5 org.kde.kded5 /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi
}

function volDown {

    pactl set-sink-volume "$active_sink" "-$inc%"
    getCurVol

    if [ ${osd} = 'yes' ]
    then
        qdbus-qt5 org.kde.kded5 /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi

}

function getSinkInputs {
    input_array=$(pactl list sinks | grep -A 15 "Estado: RUNNING" | grep -B 4 "Nombre: $1 " | awk '/Nombre/{ print $2 }')
    echo "${input_array[@]}"
}

function volSync {
    getSinkInputs "$active_sink"
    getCurVol

    for each in $input_array
    do
        pactl set-sink-input-volume "$each" "$curVol%"
    done
}

function getCurVol {
    curVol=$(pactl list sinks | grep -A 15 'Nombre: '"$active_sink"'' | grep 'Volumen:' | grep -E -v 'Volumen base:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%' | sed s/.$// | tr -d ' ')
}

function volMute {
    echo "$1"
    case "$1" in
        mute)
            pactl set-sink-mute "$active_sink" 1
            curVol=0
            status=1
            ;;
        unmute)
            echo "$active_sink"
            pactl set-sink-mute "$active_sink" 0
            getCurVol
            status=0
            ;;
    esac

    if [ ${osd} = 'yes' ]
    then
        qdbus-qt5 org.kde.kded5 /modules/kosd showVolume "${curVol}" "${status}"
    fi
}

function volMuteStatus {
    curStatus=$(pactl list sinks | grep -A 15 "Estado: RUNNING" | grep -A 15 "Nombre: $active_sink" | awk '/Silencio/{ print $2 }')
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
    firstrun=0

    pactl subscribe 2>/dev/null | {
        while true; do
            {
                # If this is the first time just continue
                # and print the current state
                # Otherwise wait for events
                # This is to prevent the module being empty until
                # an event occurs
                if [ $firstrun -eq 0 ]
                then
                    firstrun=1
                else
                    read -r event || break
                    if ! echo "$event" | grep -e "on card" -e "on sink"
                    then
                        # Avoid double events
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}

function output() {
    reloadSink
    getCurVol
    volMuteStatus

    # Set volume bar
    local percentage=$(( curVol/10 ))
    local percentage_bars="%{F#98be65}"
    for ((i = 1 ; i < 10 ; i++))
    do
        if [ "$i" = "$percentage" ]
        then
            percentage_bars+="%{F-}%{F#5B6268}"
        fi
        percentage_bars+="━"
    done
    percentage_bars+="%{F-}"

    if [ "${curStatus}" = 'sí' ]
    then
        echo "婢 $percentage_bars %{F#bbc2cf}$curVol%%{F-}"
    else
        echo " $percentage_bars %{F#bbc2cf}$curVol%%{F-}"
    fi
} #}}}

reloadSink
case "$1" in
    --up)
        volUp
        ;;
    --down)
        volDown
        ;;
    --togmute)
        volMuteStatus
        if [ "$curStatus" = 'sí' ]
        then
            volMute unmute
        else
            volMute mute
        fi
        ;;
    --mute)
        volMute mute
        ;;
    --unmute)
        volMute unmute
        ;;
    --sync)
        volSync
        ;;
    --listen)
        # Listen for changes and immediately create new output for the bar
        # This is faster than having the script on an interval
        listen
        ;;
    *)
        # By default print output for bar
        output
        ;;
esac
