for drive in `lsblk --nodeps -n -o name`; do
  result=$(/usr/sbin/smartctl -i /dev/$drive | grep Serial)
  sas=$(/usr/sbin/smartctl -a /dev/$drive | grep --count "SAS")
  issas="no"

  if [ $sas = 1 ]; then
    issas="yes"
  echo "/dev/$drive SAS: $issas $result"

  fi done
