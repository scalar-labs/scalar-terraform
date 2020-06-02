#!/bin/bash

# The log volume is already mounted by fstab entry on startup
if mountpoint -q /log; then
  # Do only chown
  chown td-agent:td-agent /log
  exit 0
fi

# Use root volume if LOG_STORE is not set
if [[ -z "$LOG_STORE" ]]; then
  # Create /log directory at the root
  echo "LOG_STORE is not set: Using Root Volume"
  mkdir -p /log
  chown td-agent:td-agent /log
  exit 0
fi

mount_log_volume () {
  local name=$1 uuid=$2

  echo "Using $name as a log volume"

  if [[ -z $uuid ]]; then
    # The volume is not formatted
    echo "Running mkfs on $name"
    if mkfs -t xfs $name; then
      uuid=$(blkid $name -s UUID -o value)
    else
      echo "mkfs failed"
      exit 1
    fi
  fi

  if ! grep -q "^UUID=$uuid" /etc/fstab; then
    echo "Adding fstab entry"
    echo "UUID=$uuid /log xfs defaults,nofail 0 2" >> /etc/fstab
  fi

  echo "Mounting $name on /log"
  mkdir -p /log
  mount /log
  chown td-agent:td-agent /log
}

# Loop over the output of lsblk to format volumes
IFS=$'\n'
for drive in $(lsblk -p -P -d -o NAME,SERIAL,UUID,HCTL | tail -n +2); do
  # For Each line in lsblk eval the output into the following variable space
  # UUID=<blank if store is not formatted>
  # SERIAL=<either vol-id or AWSxxx> If AWS it indicates local volume
  # NAME=/dev/nvmeXn1 The name is not consistant between reboots
  eval $drive

  echo "Remote Volume: $NAME"

  if [[ -z $HCTL && ${SERIAL#vol} == ${LOG_STORE#vol-} ]]; then
    # On AWS, LOG_STORE should be set to volume id
    mount_log_volume $NAME $UUID
    exit 0
  elif [[ -n $HCTL && $HCTL == *:$LOG_STORE ]]; then
    # On Azure, LOG_STORE should be set to lun (the last part of HCTL)
    mount_log_volume $NAME $UUID
    exit 0
  fi
done

# In this case the expected LOG_STORE was not found so we throw an error
echo "Cannot find LOG_STORE: $LOG_STORE"
exit 1
