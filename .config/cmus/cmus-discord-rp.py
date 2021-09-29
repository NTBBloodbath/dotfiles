#!/usr/bin/python
import os, time
from pypresence import Presence


# Transform seconds into minutes and seconds
def convert(seconds):
    min, sec = divmod(seconds, 60)
    return "%02d:%02d" % (min, sec)


# Set the RPC connection metadata
def rpc():
    client_id = "574334562201501696"
    RPC = Presence(client_id)
    RPC.connect()

    while True:
        time.sleep(1)
        if os.popen("cmus-remote -Q | grep \"status \"").read(
        ) == "status stopped\n":
            artist = "  "
            title = "  "
            current_time = "IDLE"
            small_image = None
        else:
            artist = os.popen(
                "cmus-remote -Q | grep \"tag artist\" | sed s/\"tag artist \"//"
            ).read()
            title = os.popen(
                "cmus-remote -Q | grep \"tag title\" | sed s/\"tag title \"//"
            ).read()

            if os.popen("cmus-remote -Q | grep \"status \"").read(
            ) == "status paused\n":
                current_time = "(paused)"
                small_image = "pause"
            else:
                position = convert(
                    int(
                        os.popen(
                            "cmus-remote -Q | grep \"position\" | sed s/\"position \"//"
                        ).read()))
                duration = convert(
                    int(
                        os.popen(
                            "cmus-remote -Q | grep \"duration\" | sed s/\"duration \"//"
                        ).read()))
                current_time = " (" + position + " / " + duration + ")"
                small_image = "play"

        RPC.update(details=f"{artist} - {title}",
                   state=current_time,
                   large_image="logo",
                   small_image=small_image)


if __name__ == "__main__":
    rpc()
