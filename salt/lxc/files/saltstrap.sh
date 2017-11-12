#!/bin/bash

HOST=""
ME=`ip -4 addr show lxcbr0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
MASTER=`hostname`
while getopts "h:i:m:" opt; do
  echo $opt
  case $opt in
    h) HOST="$OPTARG"
    ;;
    i) ME="$OPTARG"
    ;;
    m) MASTER="$OPTARG*"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 
  exit 1
fi

if [[ $HOST == "" ]]; then
  echo "A host must be set!"
  exit 2
fi


echo "Provisioning LXC machine $HOST with master $MASTER"
echo
echo "Updating /etc/hosts of machine to make salt point to $ME..."
lxc-attach --name=$HOST -- bash -c "echo $ME	salt >> /etc/hosts"

if [[ $? -ne 0 ]]; then
  echo "Hosts update failed!"
  echo "Quitting..."
  exit 3
fi

echo "Bootstrapping LXC container $HOST..."
salt "$MASTER*" lxc.bootstrap $HOST

if [[ $? -ne 0 ]]; then
  echo "LXC bootstrap failed!"
  echo "Quitting..."
  exit 4
fi

echo "Accepting salt-key for host $HOST..."
salt-key -a $HOST

if [[ $? -ne 0 ]]; then
  echo "Salt-key accept failed!"
  echo "Quitting..."
  exit 5
fi

echo "LXC provisioning ran successfully!"
exit 0