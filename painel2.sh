#!/bin/bash

users=$(getent passwd | cut -f1 -d":")

echo "" > dashboard2.txt

for nome in $users
do
	somacpu=0
	somamem=0
	existe=`ps -eo %mem,%cpu,user | grep $nome`

	if [[ -n $existe ]]; then
		processos=$(ps -eo %cpu,user | grep $nome |cut -f2 -d" ")
		
		for num in $processos
		do
			somacpu=`echo $somacpu + $num | bc`
		done
		
		memoria=$(ps -eo %mem,user | grep $nome |cut -f2 -d" ")

		for num in $memoria
		do
			somamem=`echo $somamem + $num | bc`
		done
		
		echo "cpu_$nome,host=hostname value=$somacpu" >> /home/ekarani/dashboard2.txt
		echo "mem_$nome,host=hostname value=$somamem" >> /home/ekarani/dashboard2.txt

	fi	
		
done

########################### Tarefas #####################
tasks=$(ps -A --no-headers | wc -l)
threads=$(ps -AL --no-headers | wc -l)

sleeping=$(ps -A --no-headers -eo stat | grep S | wc -l)


echo "tasks,host=hostname value=$tasks" >> /home/ekarani/dashboard2.txt
echo "threads,host=hostname value=$threads" >> /home/ekarani/dashboard2.txt
echo "sleeping,host=hostname value=$sleeping" >> /home/ekarani/dashboard2.txt

curl -i -XPOST 'http://localhost:8086/write?db=teste' --data-binary @/home/ekarani/dashboard2.txt
