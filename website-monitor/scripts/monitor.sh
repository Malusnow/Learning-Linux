#!/bin/bash

root="$HOME/website-monitor"
configfile="$root/config.txt"
allcheckslog="$root/data/all_checks.log"

touch "$allcheckslog"

#读取网站名及其url 跳过注释和空行

while read -r line; do
	[[ "$line" =~ ^# ]] || [[ -z "$line" ]] && continue

	name=$(echo "$line" | awk '{print $1}')
	url=$(echo "$line" |awk '{print $2}')

	mkdir -p "$root/logs/$name"

#获取网站的状态码和响应时间

	response=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" "$url" 2>/dev/null)

	status_code=$(echo "$response" | awk '{print $1}')
	resp_time=$(echo "$response" |awk '{print $2}')
	current_time=$(date "+%Y-%m-%d %H:%M:%S")

#写入日志文件
	echo "$current_time $status_code" >> "$root/logs/$name/status.log"

	echo "$current_time $name $status_code $resp_time" >> "$allcheckslog"

#当HTTP状态码非2xx/3xx时 告警到相应网站的alerts.log

	if [[ ! "$status_code" =~ ^[23][0-9]{2}$ ]];then
		echo "警告:$name $status_code" >> "$root/logs/$name/alert.log" 
	fi
done < "$configfile"
