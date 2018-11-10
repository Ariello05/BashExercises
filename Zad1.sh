#!/bin/sh

#/proc/uptime

while true
do
	uptime=$( cat /proc/uptime | awk '{print $1}' )
	uptime=$( echo "$uptime/1" | bc )
	echo Czas pracy:	
	echo w Sekundach: $uptime
	echo W Minutach: $(expr $uptime / 60)
	echo W Godzinach: $(expr $uptime / 3600)
	echo W Dniach: $(expr $uptime / 3600 / 24)

	echo Stan Baterii: $(cat /sys/class/power_supply/BAT0/uevent | grep CAPACITY= | cut -c 23-)
	echo "          -1MIN-5MIN-10MIN-"
	echo Obciazenie: $(cat /proc/loadavg | cut -c -14) 
	echo "------------------"
	sleep 1
done

