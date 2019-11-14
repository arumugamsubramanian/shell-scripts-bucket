#!/bin/bash

INSTANCE_NAME='xxxxx'
RUNNING_STATE='RUNNING'
STOP_STATE='TERMINATED'
USERNAME='xxxxxxx'
PASSWORD='xxxxx'

GCP_STATUS=`gcloud compute instances list --filter="name:$INSTANCE_NAME" --format="get(status)"`

echo $GCP_STATUS

if [ $GCP_STATUS == $STOP_STATE ]
then
	echo "The machine is already stopped"
else
	gcloud compute instances stop $INSTANCE_NAME --async
fi
