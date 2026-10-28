#!/bin/bash

#Check whether websites are up , using a list of URLs

list="${1:-sites.txt}"

if [ ! -f "$list" ]; then
	echo "Error: '$list' not found"
	exit 1
fi

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

up=0
down=0

while read -r url || [ -n "$url" ]; do
	url="${url%$'\r'}"
	[ -z "$url" ] && continue
	[[ "$url" == \#* ]] && continue
	
	code=$(curl -o /dev/null -s -W "%{http_code}" --max-time 5 "$url")
	
	if [ "$code" -ge 200 ] && [ "$code" -lt 400 ]; then
		echo -e "${GREEN}UP${RESET}  $url ($code)"
		up=$((up + 1))
	else
		echo -e "${RED}DOWN${RESET} $url ($code)"
		down=$((down + 1))
	fi
done < "$list"

echo "----------"
echo "Up: $up Down: $down"