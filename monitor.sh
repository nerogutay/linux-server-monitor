#! /usr/bin/env bash
check_service() {
if rpm -q "$1" >/dev/null
then
        if systemctl is-active --quiet "$1"
        then
                echo "$1 : ACTIVO "
	elif systemctl is-failed --quiet "$1"
	then
		echo "$1 : FALLIDO"
	else
                echo "$1 : DETENIDO"
        fi
else
        echo "$1: NO INSTALADO"
fi

}
check_disk() {
espacio=$( df -h / | awk 'NR==2 {print $5}' | sed  's/%.*//')
if [ "$espacio" -ge 90 ]
then
        echo "Estado del disco: CRITICO "
elif [ "$espacio" -ge 80 ]
then
        echo "Estado del disco: ADVERTENCIA "
else
        echo "Estado del disco: OK "
fi


echo "El disco esta a un $espacio% de uso"

}

check_memory() {

total=$( free -m | awk 'NR==2 {print $2}' )
usado=$( free -m | awk 'NR==2 {print $3}' )
porcentaje=$(( usado * 100 / $total ))

if [ "$porcentaje" -ge 90 ]
then
        echo "Estado de RAM: CRITICO "
elif [ "$porcentaje" -ge 80 ]
then
        echo "Estado de RAM: ADVERTENCIA "
else
        echo "Estado de RAM: OK "
fi


echo " total $total, usado $usado"
echo " Ram utilizada : $porcentaje%"
}
check_load() {

cpus=$(nproc)
carga=$(LC_ALL=C uptime | awk -F'load average: ' '{print $2}' | cut -d',' -f1)
porcentaje=$(echo "scale=1; ($carga * 100) / $cpus" | bc -l)

echo "==================="
echo " CARGA DEL SISTEMA"

echo " Carga 1min: $carga "
echo " CPU : $cpus "
echo " Uso relativo : $porcentaje% "


if  (( $(echo "$porcentaje >= 100 " | bc -l) ))  
then
        echo "Estado : CRITICO "
elif (( $(echo "$porcentaje >= 70" |bc -l) ))
then
        echo "Estado : ADVERTENCIA "
else
        echo "Estado : OK "
fi

}
check_cpu() {

idle=$(LC_ALL=C top -bn1 | grep "%Cpu" | awk -F',' '{for(i=1;i<=NF;i++) if($i ~ /id/) {print $i}}' | awk '{print $1}')
porcentaje=$(echo " 100 - $idle " | bc -l)
echo "==================="
echo " USO DEL CPU"

if  (( $(echo "$porcentaje >= 100 " | bc -l) ))
then
        echo "Estado : CRITICO "
elif (( $(echo "$porcentaje >= 70" |bc -l) ))
then
        echo "Estado : ADVERTENCIA "
else
        echo "Estado : OK "
fi
	
	echo " Valor de IDLE : $idle "
	echo " El CPU  actual es: $porcentaje% "
}

check_processes() {

    echo
    echo "============ PROCESOS CON MAYOR USO DE CPU ============"

    ps aux --sort=-%cpu | head -n 6

    criticos=0
    advertencias=0

    #echo
    #echo "============ EVALUACION DE PROCESOS ============"

    ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {
        cpu=$3

        if (cpu >= 80)
            estado="CRITICO"
        else if (cpu >= 50)
            estado="ADVERTENCIA"
        else
            estado="OK"

        printf "PID: %-6s CPU: %-5s%% Estado: %s\n", $2, $3, estado
    }'
}

echo "====================="
echo " ESTADO DEL SERVIDOR"
echo "====================="
check_service httpd
check_service nginx
check_service vbox
check_service mariadb
check_disk
check_memory
check_load
check_cpu
check_processes
