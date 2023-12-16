#!/bin/bash

show_uptime(){
	cat <<- _EOF_
		<h3 style="font-size:30px">UpTime : </h3>
		<pre style="font-size:25px">$(uptime)</pre>
		_EOF_
	return
}

show_resources(){
	cat <<- _EOF_
		<h3 style="font-size:30px">Resources : </h3>
		<pre style="font-size:25px">$(df -h)</pre>
		_EOF_
	return
}

show_home_space(){
	cat <<- _EOF_
		<h3 style="font-size:30px">Home Space : </h3>
		<pre style="font-size:25px">$HOME : $(du -sh /home/* | cut -f1 -d$'\t')</pre>
	_EOF_
	return
}

list_dirs_infos(){
	result="
		<table>
			<tr>
				<th>Permissions</th>
				<th>Hard-Links</th>
				<th>Owner</th>
				<th>Group</th>
				<th>Size</th>
				<th>Month</th>
				<th>Day</th>
				<th>Time</th>
				<th>File</th>
			</tr>
	"
	i=0
	while read line
	do
		if (( i<=2 )); then
			(( ++i ))
			continue
		fi
		IFS=' '	read -a array <<< $line
		row="<tr>"
		for (( j=0;j<${#array[@]};j++ ))
		do
			row="$row<td>${array[$j]}</td>"
		done
		row="$row</tr>"
		result="$result$row"
		(( ++i ))
	done <<< "$(ls -la)"
	result="$result</table>"
	cat <<- _EOF_
	$result
	_EOF_

	return
}

declare -r NAME="Show Sysinfos"
current_date="$(date +\"%x\")"
current_time="$(date +\"%r\")"

echo "<html>
	<head>
	<title>$NAME</title>
	<style>
		table,th,td {
			border: 3px solid black;
			border-collapse: collapse;
		}
	</style>
	</head>
	<body>
		<h1>Welcome to : $NAME Website</h1>
		<h2>Current Date : $current_date</h2>
		<h3>Current Time : $current_time</h3>
		<p style="font-size:25px">
		Current working directory : $PWD<br>
		Infos:<br>
		$(show_uptime)
		$(show_resources)
		$(show_home_space)
		$(list_dirs_infos)
		</p>
	</body>
</html>" > index.html
firefox index.html
