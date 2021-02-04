#!/bin/bash
source $HOME/.bashrc

URL="https://api.telegram.org/bot$ArgoEsBotTOKEN/sendMessage"
MENSAJE=`cat $HOME/Dropbox/Oceanografia/Proyectos/SSTWebpage/data/report.txt`
curl -s -X POST $URL -d chat_id=$ArgoEsChannel -d text="$MENSAJE" -d parse_mode=html  
