#! /bin/bash
## Author : Ahmed Sellami ##

version_question(){
	tries=3
	until [[ "$tries" == 0 ]]; do
		read -p "What's the version of $1? (You have $tries tries) : " ver
		if [[ "$ver" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
			if [[ "$ver" == $2 ]]; then
				echo "Correct!"
				return 0
			else
				echo "Nope!"
			fi
		else
			echo "Version must a number and maybe a floating one"
		fi
		(( tries-- ))
	done
	echo "Right Answer : $2"
	return 1
}

date_question(){
	tries=3
	until [[ "$tries" == 0 ]]; do
		read -p "What's the date of $1? (You have $tries tries): " chosen_date
		if [[ "$chosen_date" =~ ^([0-9]{2}\/){2}[0-9]{4}$ ]]; then
			if [[ "$chosen_date" == $2 ]]; then
				echo "Correct!"
				return 0
			else
				echo "Nope!"
			fi
		else
			echo "Date must be in the format MM/DD/YYYY"
		fi
		(( tries-- ))
	done
	echo "Right Answer : $2"
	return 1
}

i=0
while read -a data; do
	distro=""
	for (( k=0;k<${#data[@]};k++ )); do
		if [[ ${data[$k]} =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
			break
		fi
		if [[ "$k" == 0 ]]; then
			distro="${data[$k]}"
		else
			distro="$distro ${data[$k]}"			
		fi
	done
	version=${data[$k]}
	date=${data[$((k+1))]}
	echo "Distro : $distro"$'\n'"Version : $version"$'\n'"Date : $date"
	echo "_____________________________________________________________"$'\n'
	distros[$i]="$distro"
	versions[$i]="$version"
	dates[$i]="$date"
	(( i++ ))
done < distros.txt
sleep 2
while true; do
	clear
	for (( j=0;j<i;j++ )); do
		echo "$((j+1))) ${distros[$j]}"
	done
	read -p "Choose Distro [1-${#distros[@]}] (write 'q' to quit): " chosen
	if [[ "$chosen" == "q" ]]; then
		echo "Terminating Script"
		sleep 2
		break
	elif [[ "$chosen" =~ ^-?[0-9]+$ ]]; then
		if [ "$chosen" -lt 1 ] || [ "$chosen" -gt "${#distros[@]}" ]; then
			echo "Distro number must be in the range [1-${#distros[@]}]"
			sleep 2
			continue
		else
			(( chosen-- ))
			version_question "${distros[$chosen]}" "${versions[$chosen]}"
			answer1="$?"
			date_question "${distros[$chosen]}" "${dates[$chosen]}"
			answer2="$?"

			if [ "$answer1" -eq "0" ] && [ "$answer2" -eq "0" ]; then
				echo "You got 2/2"
			elif [ "$answer1" -eq "0" ] || [ "$answer2" -eq "0" ]; then
				echo "You got 1/2"
			else
				echo "You got 0/2"
			fi
			sleep 5
		fi
	else
		echo "Choose a number please !"
		sleep 2
		continue
	fi
done
