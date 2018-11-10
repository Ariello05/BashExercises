#!bin/sh


echo "  PID   PPID   UID   GID    STATE |NAME"
#text="PID PPID\n"
for file in $(find /proc/* -maxdepth 0 -type d -iname "[0-9]*")
do
	file="$file/status"
	#read $file
	#text=$(cat < $file)
	if [ -e $file ];
	then
		x=0
	    	
		#cat $file |  (while read line;
		#do
		#	x=$(( x+1 ))
		#	if [ $x -eq "6" ]; then
		#		pid=$(echo $line | cut -c 6-)		
		#	fi
		#	if [ $x -eq "7" ]; then
		#		ppid=$(echo $line | cut -c 7-)
		#		break
		#	fi
		#done && printf "%-5s %s %s\n" $pid $ppid )	
		
		# lines are fixed 
		name=$(  head -n 1 $file  | tail -1 | cut -f 2-3 )
		state=$( head -n 3 $file  | tail -1 | cut -c 7-9 )
		pid=$(   head -n 6 $file  | tail -1 | cut -c 6-  )
		ppid=$(  head -n 7 $file  | tail -1 | cut -c 7-  )
 		uid=$(   head -n 9 $file  | tail -1 | cut -c 5-7 )		
		gid=$(   head -n 10 $file | tail -1 | cut -c 5-7 ) 

		printf "%5s %5s %5s %5s %6s    | %s\n" $pid $ppid $uid $gid $state $name
	fi
done
