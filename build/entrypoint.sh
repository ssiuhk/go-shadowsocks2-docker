#!/bin/sh
set -ex

# Start forego or execute a command in the virtualenv
DATETIME=$(date +%Y%m%d%H%M%S)
mkdir -p $HOME/logs

if [ "$#" -eq 0 ]; then

    export | grep SS_PORT_ | grep -v '\_PW' | awk '{print $2}' | while read CONFIG
    do
         KEYNAME=$(echo $CONFIG | cut -f1 -d '=' | tr -d "'")
         PORT=$(echo $CONFIG | cut -f2 -d '=' | tr -d "'")
         PASSWORD=$(export | grep '\_PW' | grep ${KEYNAME} | cut -f2 -d '=' | tr -d "'")
         $HOME/go/bin/go-shadowsocks2 -s "ss://AEAD_CHACHA20_POLY1305:${PASSWORD}@:$PORT" -verbose > $HOME/logs/${KEYNAME}_${DATETIME}.log 2>&1 &
    done

    LAST_LOG_FILE=$(ls -altr $HOME/logs/ | grep "SS_PORT" | head -n1 | awk '{print $NF}')
    tail -f $HOME/logs/$LAST_LOG_FILE

else
        "$@"
fi

