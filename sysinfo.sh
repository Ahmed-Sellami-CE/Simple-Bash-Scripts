#! /bin/bash
## Author : Ahmed Sellami ##

DELAY=1.2
while [[ "$choice" != 0 ]]
do
	clear
	cat <<- _EOF_
		Please Select:
		1. Display System Information
		2. Display Disk Space
		3. Display Home Space Utilization
		0. Quit
	_EOF_
	read -p "Enter choice [0-3]: " choice
	if [[ "$choice" =~ ^[0-3]$ ]]; then
		if [[ "$choice" == "1" ]]; then
			echo "Hostname : $HOSTNAME"
			uptime
			sleep $DELAY
		elif [[ "$choice" == "2" ]]; then
			df -h
			sleep $DELAY
		elif [[ "$choice" == "3" ]]; then
			if [[ $(id -u) == 0 ]]; then
				echo "From root user"
				du -sh "/home"
			else
				echo "From $(whoami) user"
				du -sh ~
			fi
			sleep $DELAY
		fi
	else
		echo "Enter a number in [0-3]"
		sleep $DELAY
	fi
done
echo "Program terminated"
