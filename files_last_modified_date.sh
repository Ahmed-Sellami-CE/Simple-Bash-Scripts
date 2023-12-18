#! /bin/bash
## Author : Ahmed Sellami ##
hour_file(){
	modified="$(stat "$1" | grep "Modify")"
	if [[ "$modified" =~ .*([0-9]{4}\-[0-9]{2}\-[0-9]{2}).*([0-9]{2}:[0-9]{2}:[0-9]{2}).* ]]; then
		file_date="${BASH_REMATCH[1]}"
		file_hour="${BASH_REMATCH[2]}"
	fi
	cat <<- _EOF_
		<tr>
			<td>$1</td>
			<td>$file_date</td>
			<td>$file_hour</td>
		</tr>
	_EOF_
	return
}

hour_directory(){
	while read file; do
		if [[ "${1: -1}" == "/" ]]; then
			result="$1"$file""
		else
			result="$1"/$file""	
		fi
		type_file="$(ls -lad "$result")"
		if [[ "${type_file:0:1}" == 'd' ]]; then
			cat <<- _EOF_
				<tr>
					<th colspan="3">Changing Directory to : $file</th>
				</tr>
			_EOF_
			hour_directory "$result"
			cat <<- _EOF_
				<tr>
					<th colspan="3">Returning to : $1</th>
				</tr>
			_EOF_
		elif [[ "${type_file:0:1}" == '-' ]]; then
			hour_file "$result"
		fi
	done <<< "$(ls "$1")"
}

heute=$(date "+%Y-%m-%d %H:%M:%S")
if [[ -n "${1:-.}" ]]; then
	if [[ -f "$1" ]]; then
		hour_file "${1:-.}"
	elif [[ -d "$1" ]]; then
		result="
			<html>
			<head>
			<title>Files in ${1:-.}: Time/Date</title>
			<style>
			table,th,td {
				border: 3px solid black;
				border-collapse: collapse;
				text-align: center;
				padding-left: 50px;
				padding-right: 50px;
				margin: 0 auto;
				font-size: 25px;
			}
			</style>
			</head>
			<body>
			<h1>Reading files and when they were last modified in : ${1:-.} <h1>
			<table>
			<tr>
				<th>File Name</th>
				<th>Date</th>
				<th>Time</th>
			</tr>
			$(hour_directory "${1:-.}")
			</table>
			</body>
			</html>"
		echo -n "$result" > "index.html"
		echo "Creating index.html file ..."
		read -p "Do you want to show the webpage? [Y/n] : " ex
		case $ex in
			"y"|"Y" ) echo "Opening Firefox ..." 
				sleep 2
				firefox "index.html"
				;;
			"n"|"N" ) echo "Terminating the program ..."
				sleep 2
				;;
		esac
	else
		echo "${1:-.} doesn't exist !"
	fi
fi
