#!/bin/bash

HOST=""
MASTER='salt'
HYPERVISOR=`hostname`
while getopts "h:i:m:" opt; do
  echo $opt
  case $opt in
    h) HOST="$OPTARG"
    ;;
    i) MASTER="$OPTARG"
    ;;
    m) HYPERVISOR="$OPTARG*"
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


echo "Provisioning LXC machine $HOST on $HYPERVISOR."
echo

echo "Bootstrapping LXC container $HOST..."
salt "$HYPERVISOR*" lxc.bootstrap $HOST

if [[ $? -ne 0 ]]; then
  echo "LXC bootstrap failed!"
  echo "Quitting..."
  exit 3
fi

echo "Updating /minion config of machine to make salt point to $MASTER..."
lxc-attach --name=$HOST -- bash -c "echo master: $MASTER >> /etc/salt/minion"

if [[ $? -ne 0 ]]; then
  echo "Hosts update failed!"
  echo "Quitting..."
  exit 4
fi

echo 'Restarting minion...'
lxc-attach --name=$HOST -- bash -c "systemctl restart salt-minion"

if [[ $? -ne 0 ]]; then
  echo "Minion restart failed!"
  echo "Quitting..."
  exit 5
fi

echo "Accepting salt-key for host $HOST..."
salt-key -a $HOST -y

if [[ $? -ne 0 ]]; then
  echo "Salt-key accept failed!"
  echo "Quitting..."
  exit 6
fi

echo "LXC provisioning ran successfully!"
exit 0