#!/bin/bash

INSTANCE_NAME='xxxxx'
RUNNING_STATE='RUNNING'
STOP_STATE='TERMINATED'
USERNAME='xxxxxxxx'
PASSWORD='xxxxxxx'

GCP_STATUS=`gcloud compute instances list --filter="name:$INSTANCE_NAME" --format="get(status)"`

echo $GCP_STATUS

if [ $GCP_STATUS == $STOP_STATE ]
then
	echo "The machine is not running, so going to start"
	gcloud compute instances start $INSTANCE_NAME
	if [ $? != 0 ]
	then 
		echo "failed while bringing up the server"
		exit 1
	fi
	IP_ADDRESS=`gcloud compute instances describe $INSTANCE_NAME --format="get(networkInterfaces[0].accessConfigs[0].natIP)"`
	echo "wait for 60 seconds and then RDP to $IP_ADDRESS"
	sleep 60
	./mstscup.bat "$IP_ADDRESS" "$USERNAME" "$PASSWORD" | exit 0
else
	GET_INSTANCE_STATUS=`gcloud compute instances list --filter="name:$INSTANCE_NAME" --format="get(status)"`
	if [ $GET_INSTANCE_STATUS == $RUNNING_STATE ]
	then
		IP_ADDRESS=`gcloud compute instances describe $INSTANCE_NAME --format="get(networkInterfaces[0].accessConfigs[0].natIP)"`
		echo "wait for 10 seconds and then RDP to $IP_ADDRESS"
		sleep 1
		./mstscup.bat "$IP_ADDRESS" "$USERNAME" "$PASSWORD" | exit 0
	fi
fi
