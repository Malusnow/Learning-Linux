#!/bin/bash

root="$HOME/website-monitor"
reports="$root/reports"
allcheckslog="$root/data/all_checks.log"

yesterday=$(date -d "yesterday" "+%Y-%m-%d")

reportsfile="$root/reports/daily_report_$yesterday.txt"

echo "网站监控日报告:$yesterday" > "$reportsfile"
echo "---" >> "$reportsfile"

echo "网站可用性摘要:" >> "$reportsfile"
grep "$yesterday" "$allcheckslog" | awk '{print $3,$4}' | sort | uniq -c | awk '{print $2,$3,"出现次数:", $1}' >> "$reportsfile"

echo "异常情况:" >> "$reportsfile"

find "$root" -name "alerts.log" | while read -r alertfile;do
	grep "$yesterday" "$alertfile" >> "$reportsfile"
done
