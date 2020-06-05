#!/bin/sh

function getOpen(){	
	find $1 | wc -l #no directories
}

echo "  PID   PPID   UID   GID  STATE  OPEN   | NAME"
for file in $(find /proc/* -maxdepth 0 -type d -iname "[0-9]*")
do
	fd="$file/fd"
	file="$file/status"
	if [ -e $file ];
	then
		x=0
	    	
		# lines are fixed 
		name=$(  head -n 1 $file  | tail -1 | cut -f 2-3 )
		state=$( head -n 3 $file  | tail -1 | cut -c 7-9 )
		pid=$(   head -n 6 $file  | tail -1 | cut -c 6-  )
		ppid=$(  head -n 7 $file  | tail -1 | cut -c 7-  )
 		uid=$(   head -n 9 $file  | tail -1 | cut -c 5-7 )		
		gid=$(   head -n 10 $file | tail -1 | cut -c 5-7 ) 
		open=$(getOpen $fd)
		printf "%5s %5s %5s %5s %5s %6s    | %s\n" $pid $ppid $uid $gid $state $open $name
	fi
done
