#! /bin/bash
## Author : Ahmed Sellami ##

declare -A owners groups

show_all(){
	show_files "$1"
	show_owners
	show_groups
}
show_files(){
	while read line; do
	array=($line)
	if [[ "${#array[@]}" -gt 3 ]]; then
		(( owners["${array[2]}"]++ ))
		(( groups["${array[3]}"]++ ))
		cat <<- _EOF_
		<tr>
			<td>$(realpath $1)/${array[$(( ${#array[@]}-1 ))]}</td>
			<td>${array[2]}</td>
			<td>${array[3]}</td>
		</tr>
		_EOF_
	fi
	done <<< "$(ls -l $1)"
	cat <<- _EOF_
		</table>
	_EOF_
}

show_owners(){
	owner_keys=(${!owners[@]})
	cat <<- _EOF_
	<h1>${#owner_keys[@]} file owners : </h1>
	<table>
			<tr>
				<th>File Owners</th>
				<th>Number Of Files</th>
			</tr>
	_EOF_
	for i in "${owner_keys[@]}"; do
		cat <<- _EOF_
		<tr>
			<td>$i</td>
			<td>${owners[$i]}</td>
		</tr>
		_EOF_
	done
	cat <<- _EOF_  
		</table>
	_EOF_
}

show_groups(){
	group_keys=(${!groups[@]})
	cat <<- _EOF_
	<h1>${#group_keys[@]} file groups : </h1>
	<table>
			<tr>
				<th>File Groups</th>
				<th>Number Of Files</th>
			</tr>
	_EOF_
	for j in "${group_keys[@]}"; do
	cat <<- _EOF_
		<tr>
			<td>$j</td>
			<td>${groups[$j]}</td>
		</tr>
		_EOF_
	done
	cat <<- _EOF_
		</table>
	_EOF_
}

dir=
if [[ -z "$1" ]]; then
	read -p "Enter a directory : " dir
fi
if [[ ! -d "${1:-"$dir"}" ]]; then
	echo "Failed! directory not specified!"
	exit 1
fi
complete=0
result="
			<html>
			<head>
			<title>Files in ${1:-"$dir"}: Owners/groups</title>
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
			<h1>Files/file owners/file group owners in : ${1:-"$dir"} <h1>
			<table>
			<tr>
				<th>File Name (Absolute Path)</th>
				<th>File Owner</th>
				<th>File Group Owner</th>
			</tr>
			$(show_all ${1:-"$dir"})
			</body>
			</html>"

echo -n "$result" > "index.html"
firefox "index.html"
exit
