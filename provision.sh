#!/bin/bash -x
dockerVersion=$1
key=$2
authorizedKeys=/home/rancher/.ssh/authorized_keys

echo Adding public to $user ~/.ssh/authorized_keys
grep "$key" $authorizedKeys
if [ $? -eq 1 ]; then
  echo $key >> $authorizedKeys
  chmod 0600 $authorizedKeys
fi

echo Switching to supported Docker version $dockerVersion
ros engine switch $dockerVersion

