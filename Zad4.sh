#!/bin/sh
if [ $# -lt 2 ]; then
	printf "THERE NEED TO BE 2 ARGS \n"
	printf "1: Site url \t 2: Refresh rate in seconds  \t 3: [OPTIONAL] History Count \n"
	exit 1
fi

wyjdz() {
	rm "./strona/strona.txt"
	rm "./strona/strona2.txt"
	zapisz "$1" "$2"

	echo "Limit historii osiagniety."
	exit 1
}

zapisz() {
	printf "Changes made, written to: %s\n" ./strona/changes$2.txt
	echo "$1" > "./strona/changes$2.txt"
	echo "$1"
}

if [ ! -d strona ]; then
	mkdir strona
fi

lynx -dump $1 > ./strona/strona.txt
cp strona/strona.txt ./strona/original.txt

count=0
i=0
while true
do
	if [ $(($i+1)) -gt $2 ]; then
	
		lynx -dump $1 > ./strona/strona2.txt
		dif=$(diff ./strona/strona.txt ./strona/strona2.txt)

		if [ "$dif" != "" ]; then
			((count++))
			if [ "$count" -eq ${3:-1} ] || [ "$count" -gt ${3:-1} ]; then
				#zapisz "$dif" "$count"
				wyjdz "$dif" "$count"
			
			fi
			zapisz "$dif" "$count"
			mv ./strona/strona2.txt ./strona/strona.txt
		else
			printf "No changes \n"
		fi

		i=0
	fi

	sleep 1
	((i++))
	printf "I: %d \t COUNT: %d \n" $i $count
done


