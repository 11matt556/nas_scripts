drive_string=""
for drive in `lsblk --nodeps -n -o name`; do

drive_string+="/dev/$drive "

done

watch -n 1 /usr/sbin/hddtemp $drive_string
