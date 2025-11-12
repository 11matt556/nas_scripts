RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

results=""
for drive in `lsblk --nodeps -n -o name`; do
  #sas=$(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS")
  issas="no"

  hctl="$(lsblk --nodeps -no hctl /dev/$drive)"

  if [ $(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS") = 1 ]; then
    tmp=$(/usr/sbin/smartctl -i /dev/$drive | grep Serial)
    serial=${tmp/#"Serial number:        "}
    issas="${GREEN}yes${ENDCOLOR}"
  else
    serial="$(lsblk --nodeps -no serial /dev/$drive)"
    issas="${RED}no${ENDCOLOR}"
  fi

  size=$(lsblk --nodeps -no size /dev/$drive)
  
  raid=$(/usr/sbin/mdadm -Q /dev/$drive | tail -1)
  
  if [ $(/usr/sbin/mdadm -Q /dev/$drive | tail -1 | grep --count "device active") = 1 ]; then
    raid="active"
  elif [ $(/usr/sbin/mdadm -Q /dev/$drive | tail -1 | grep --count "device mismatch") = 1 ]; then
    raid="failure"
  else
    raid="inactive"
  fi
  

  #echo "/dev/$drive SAS: $issas Serial: $serial Size: $size hctl: $hctl"
  results+="/dev/$drive $issas $size $hctl $raid $serial\n"
done

print_var=""
#for result in ${results[@]}; do
  #echo $result
  #printvar+=$($result)
#done

#echo -e $results

(echo -e "DRIVE SAS SIZE HCTL RAID SERIAL\n"; echo -e $results) | column -t
