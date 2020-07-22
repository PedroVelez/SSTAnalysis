#!/bin/bash

URL="https://api.telegram.org/bot$ArgoEsBotTOKEN/sendMessage"
MENSAJE=`cat $HOME/Dropbox/Oceanografia/Proyectos/SSTWebpage/data/report.txt`
curl -s -X POST $URL -d chat_id=$ArgoEsBotID -d text="$MENSAJE" -d parse_mode=html
