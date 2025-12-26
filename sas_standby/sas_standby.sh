#!/bin/bash

mdadm_hdd=$(/sbin/blkid | grep omv-nas  | grep -oP '\/dev\/sd[a-z]')

#echo "$mdadm_hdd"

standby=''
bms=''
help='false'

set_standby () { standby=$1; }
set_bms () { bms=$1; }
helpmenu () { help='true'; }

if [[ $# == 0 ]]; then
	helpmenu
fi


while [ ! $# -eq 0 ]
do
	case "$1" in
        --standby | -s)
        	shift
        	set_standby $1
		;;
	--bms | -b)
		shift
		set_bms $1
		;;
        --help | -h)
		helpmenu
		;;
	*)
		echo "Unknown Parameter"
		helpmenu
		;;
	esac
	shift
done

if [[ $help == 'true' ]]; then
	echo ""
	echo "USAGE"
	echo "sas_standby.sh PARAMETERS"
	echo ""
	echo "PARAMETERS"
        echo "--standby, -s {enable,disable}    : Enables or disables the standby functionality. "
        echo "--bms,     -b {enable,disable}    : Enables or disables BMS"
        echo "--help,    -h                     : Displays this help"
	echo ""
	exit 0
fi


for drive in $mdadm_hdd; do

	if [[ $bms == 'enable' ]]; then
		echo "Enable BMS on $drive"
		sdparm $drive -p bc -s EN_BMS=1
	fi

        if [[ $bms == 'disable' ]]; then
		echo "Disable BMS on $drive"
                sdparm --clear=EN_BMS --save $drive
        fi

        if [[ $standby == 'enable' ]]; then
		echo "Enable standby on $drive"
                sdparm --flexible -6 -l --save --set SCT=18000 $drive # sct is in 100ms
		sdparm --flexible -6 -l --save --set STANDBY=1 $drive
        fi

        if [[ $standby == 'disable' ]]; then
		echo "Disable standby on $drive"
        	sdparm --flexible -6 -l --save --set STANDBY=0 $drive
        fi

done
