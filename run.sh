#!/bin/bash - 
#===============================================================================
#
#          FILE: run.sh
# 
#         USAGE: ./run.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/13/2020 09:29
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
if [[ $# -lt 1 || $# -gt 3 ]]; then
	echo -e "Usage:\n\t this_file host [note [uuid]] "
	exit 130
fi
host=$1
comm=V2RAY
if [[ $# -ge 2 ]]; then
	comm=$2
fi
#uuid=c805b972-833e-48f2-b5fb-65d11c33dfd1
uuid=""
if [[ $# -eq 3 ]];  then
	uuid=$3
fi

sudo docker run -dit --restart always --name v2ray -p 443:443 -p 80:80 -v $HOME/.caddy:/root/.caddy  darkshell/v2ray:latest $host $comm $uuid && sleep 3s && sudo docker logs v2ray
