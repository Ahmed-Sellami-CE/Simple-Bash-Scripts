#! /bin/bash
## Author : Ahmed Sellami ##

read -p "Enter Username : " -s -t 5 username
infoline=$(cat "/etc/passwd" | grep -E "^$username")
if [[ -n $infoline ]]; then
	IFS=: read user pw uid gid name home shell <<< "$infoline"
	echo $'\n'"user=$user"$'\n'"pw=$pw"$'\n'"uid=$uid"$'\n'"gid=$gid"$'\n'"name=$name"$'\n'"home=$home"$'\n'"shell=$shell"
else
	echo $'\n'"No such a user" >&2
	exit 1
fi
exit
