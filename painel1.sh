#!/bin/bash

cpu=$(iostat -c | grep , | cut -f6 -d"," | cut -f4 -d" ")

livre=$(cat /proc/meminfo | grep MemFree | cut -f2 -d":" | cut -f1 -d"k")
total=$(cat /proc/meminfo | grep MemTotal | cut -f2 -d":" | cut -f1 -d"k")
usado=$(expr $total - $livre)

porcentagemUsed=$(expr $usado \* 100 / $total)
cpuUsage=$(( 100 - $cpu))


horas=$(snmpget -v2c -c public localhost hrSystemUptime.0 | cut -f4 -d":" | cut -f2 -d")" | cut -f2 -d" ")
minutos=$(snmpget -v2c -c public localhost hrSystemUptime.0 | cut -f5 -d":")
segundos=$(snmpget -v2c -c public localhost hrSystemUptime.0 | cut -f6 -d":")


echo "time_hours,host=hostname value=$horas" > /home/ekarani/dashboard1.txt

echo "time_minutes,host=hostname value=$minutos" >> /home/ekarani/dashboard1.txt

echo "time_seconds,host=hostname value=$segundos" >> /home/ekarani/dashboard1.txt

echo "cpu_load,host=hostname value=$cpuUsage" >> /home/ekarani/dashboard1.txt

echo "mem_load,host=hostname value=$porcentagemUsed" >> /home/ekarani/dashboard1.txt

curl -i -XPOST 'http://localhost:8086/write?db=teste' --data-binary @/home/ekarani/dashboard1.txt



