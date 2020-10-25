#!/bin/bash
for drive in `lsblk --nodeps -n -o name`; do
  result=$(/usr/sbin/smartctl -a /dev/$drive | grep --count "SMART Health Status: OK")
  sas=$(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS")
  if [ $sas = 1 ]; then
    if [ $result = 1 ]; then
      echo $drive "SMART OK"
    else
      echo $drive "SMART FAILURE"
      smartctl -a /dev/$drive | mail -s "SMART FAILURE DETECTED ON DRIVE $drive" 11yahoo556@gmail.com
    fi
   else
     echo "$drive is not a SAS drive"
  fi done