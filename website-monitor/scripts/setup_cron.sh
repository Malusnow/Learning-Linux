#!/bin/bash

root="$HOME/website-monitor"

(crontab -l 2>/dev/null; echo "*/15 * * * * $root/scripts/monitor.sh >> $root/logs/cron_monitor.log 2>&1") | crontab -

(crontab -l 2>/dev/null; echo "* 1 * * * $root/scripts/generate_report.sh >> $root/logs/cron_report.log 2>&1") | crontab -

echo "定时任务已设置："
echo "1. 每15分钟运行监控脚本"
echo "2. 每天凌晨1点生成日报"
