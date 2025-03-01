for drive in `lsblk --nodeps -n -o name`; do
  #sas=$(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS")
  issas="no"

  if [ $(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS") = 1 ]; then
    tmp=$(/usr/sbin/smartctl -i /dev/$drive | grep Serial)
    result=${tmp/#"Serial number:        "}
    issas="yes"
  else
    result="$(lsblk --nodeps -no serial /dev/$drive)"
    issas="no "
  fi

  size=$(lsblk --nodeps -no size /dev/$drive)

  echo "/dev/$drive SAS: $issas Serial: $result Size: $size"
done
