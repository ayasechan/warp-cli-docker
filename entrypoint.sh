#!/bin/bash

(
    if [ ! -f /var/lib/cloudflare-warp/reg.json ]; then
       while ! warp-cli --accept-tos registration new ; do
            sleep 1
            >&2 echo "Awaiting warp-svc become online..."
        done
    fi

    if [ ! -z $LICENSE ]; then
	    warp-cli --accept-tos registration license "$LICENSE"
    fi

    warp-cli --accept-tos mode proxy
    # warp listen localhost only
    warp-cli --accept-tos proxy port 40001
    warp-cli --accept-tos connect
    # forward port
    socat TCP-LISTEN:40000,fork TCP:localhost:40001 &
    
) &

exec warp-svc  
