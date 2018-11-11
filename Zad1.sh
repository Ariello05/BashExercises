#!/bin/sh

#/proc/uptime

function showBattery() {
	printf "BATERRY: %s\n" $1%
	printf "─%.0s" {1..50}
	echo
	i=0
	let "a= $1 / 2"
	while [ "$a" -gt "$i" ]; do
		printf "░"
		((i++))
	done
	echo
	printf "─%.0s" {1..50}
	printf "\n"
}

function showUpTime() {
	printf " %.0s" {1..9}
       	printf "%35s UPTIME\n"
	printf "%35s %s  %s  %s   %s\n" "" SECS MINS HOUR DAYS
	printf "%35s"
	printf "━%.0s" {1..25}
	printf "\n%35s"
	printf "│%5s" $1
	printf "│%5s" $(expr $1 / 60)
	printf "│%5s" $(expr $1 / 3600)
	printf "│%5s│" $(expr $1 / 3600 / 24)
	printf "\n%35s"
	printf "━%.0s" {1..25}
	printf "\n"
}

function setBatteryColor() {

	if [ "$1" -lt 20 ]; then
		tput setaf 11 #yellow
	elif [ "$1" -lt 5 ]; then
		tput setaf 1 #red
	else
		tput setaf 4 #blue
	fi
}

j=0
flag=0
function showProcAvg() {
	printf "%35s AVERGAVE JOBS PER 1 MINUTE\n" " "

	for index in {20..1}; do
		printf "%3s┊" ""
	       	#$(($index*10))
		local index2=0
		tput setaf 202
		while [ "$index2" -lt "$j" ];do
			x=${procloadValue[$index2]}
			if [ "$index" -lt "$x" ] || [ "$index" -eq "$x" ]; then	
				printf "│▓│"
			else
				printf "│░│"
			fi
			((index2++))
		done
		tput sgr0
		printf "\n"
	done

	printf "    "
	printf "┈%.0s" {1..90}
	printf "\n"
	printf "   "

	local index=0
	while [ "$index" -lt 29 ]; do
		printf "  %3s " ${procload[$index]}
		let index=$index+2	
	done

	echo
	#echo AVG: $1 $2 $3
	local num=$(bc -l <<<"$1*10")
	procloadValue[$j]=$(printf "%.0f" $num)
	local num=$(bc -l <<<"$num*10")
	procload[$j]=$(printf "%.0f" $num)

	if [ ! "$flag" -eq 1 ]; then
		((j++))
		if [ $j -gt 29 ]; then
			flag=1
			echo flaga ustawiona
		fi
	else
		local i1=0
		local i2=1
		while [ "$i1" -lt 30 ]
		do
			procload[$i1]=${procload[$i2]}
			procloadValue[$i1]=${procloadValue[$i2]}
			((i1++))
			((i2++))
		done
	fi

}


while true
do
	uptime=$( cat /proc/uptime | awk '{print $1}' )
	uptime=$( echo "$uptime/1" | bc )
	showUpTime $uptime	
	printf "\n\n"
	
	load=$(cat /proc/loadavg | cut -c -14)
	showProcAvg $load

	printf "\n\n"

	battery=$(cat /sys/class/power_supply/BAT0/uevent | grep CAPACITY= | cut -c 23-)
	setBatteryColor $battery
	showBattery $battery 
	tput sgr0;#reset

	sleep 1
	clear
done


