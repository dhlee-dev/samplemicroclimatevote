#!/bin/bash
#*******************************************************************************
# Licensed Materials - Property of IBM
# "Restricted Materials of IBM"
#
# Copyright IBM Corp. 2018 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#*******************************************************************************

export CONTAINER_NAME=$1

export CONTAINER_IMAGE_NAME=$2

export IDC_APP_BASE=$3

export MICROCLIMATE_WS_ORIGIN=$4

# The directory that contains this shell script (which is also the installation artifact/ dir)
export ARTIFACTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# App dir
export APPDIR=`pwd`

export APPNAME=$(dirname $APPDIR)

export PROJNAME=$(basename $APPDIR)

export LOGSDIR=$ARTIFACTS/.logs

export HELMDIR=$IDC_APP_BASE/idc-helm

export RELEASE_NAME=$CONTAINER_NAME

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

if [[ -z $PVC_NAME ]]; then
	# Only grab the PVC name if it wasn't passed in by the helm chart
	PVC_NAME="$( kubectl get pvc -o=custom-columns=NAME:.metadata.name | grep '\-ibm-microclimate' )";
fi

if [[ $MICROCLIMATE_WS_ORIGIN &&  $APPDIR == '/microclimate-workspace'* ]]
    then

		# The main MicroProfile directory is the parent of the microclimate workspace
		MICROCLIMATE_ORIGIN_DIR=${MICROCLIMATE_WS_ORIGIN%'/microclimate-workspace'}

		# The app directory is originally in the format /microclimate-workspace/<app name>
		APPDIR=$MICROCLIMATE_ORIGIN_DIR$APPDIR

		# The artifacts directory is in the main microprofile directory
		ARTIFACTS=$MICROCLIMATE_ORIGIN_DIR/docker/file-watcher/idc/artifacts

		LOGSDIR=$MICROCLIMATE_WS_ORIGIN/.logs
fi

# Create the log directory if it doesn't already exist, app dir will already exist
mkdir -p $LOGSDIR
mkdir -p $HELMDIR

# Copy helm chart template over to .idc folder
# TODO: Look into generating helm chart as part of IDC process
cp -rf /idc/artifacts/masterHelmCharts/idc-helm/. $HELMDIR
cd $HELMDIR

# Delete helm release if one already exists (because we need to use helm install instead of upgrade)
if [[ "$( helm list $RELEASE_NAME )" ]]; then
	echo "Deleting old helm release $RELEAE_NAME"
	helm delete $RELEASE_NAME --purge
fi

# Tag and push the image to the registry
if [[ ! -z $DOCKER_REGISTRY ]]; then	
	# Tag and push the image
	docker tag $CONTAINER_NAME $DOCKER_REGISTRY/$CONTAINER_NAME
	docker push $DOCKER_REGISTRY/$CONTAINER_NAME
	
	helm install --name $RELEASE_NAME . \
		--values=/scripts/override-values-icp.yaml \
		--set volume.pvc.name=$PVC_NAME \
		--set image.repository=$DOCKER_REGISTRY/$CONTAINER_NAME \
		--set project.name=$PROJNAME \
		--set user.name=$MICROCLIMATE_USER \
		--set microclimate.release.name=$MICROCLIMATE_RELEASE_NAME
else
	helm install --name $RELEASE_NAME . \
		--set volume.pvc.name=$PVC_NAME \
		--set image.repository=$CONTAINER_NAME \
		--set project.name=$PROJNAME \
		--set user.name=$MICROCLIMATE_USER \
		--set microclimate.release.name=$MICROCLIMATE_RELEASE_NAME
fi

# Don't proceed if the helm install failed
if [[ $? -ne 0 ]]; then
	echo "Failed to install Helm chart for release $RELEASE_NAME, exiting"
	exit 1;
fi

# Wait until the pod is up and running
POD_RUNNING=0
while [ $POD_RUNNING -eq 0 ]; do
	RESULT="$( kubectl get po --selector=release=$RELEASE_NAME )"
	if [[ $RESULT = *"Running"* ]]; then
		POD_RUNNING=1
	elif [[ -z "$RESULT" || $RESULT = *"Failure"* || $RESULT = *"Unknown"* || $RESULT = *"ImagePullBackOff"* || $RESULT = *"CrashLoopBackOff"* || $RESULT = *"PostStartHookError"* ]]; then
		echo "Error: Pod for Helm release $project failed to start"
		helm delete $RELEASE_NAME --purge
		exit 1;
	fi
	sleep 1;
done

echo "The pod for helm release $RELEASE_NAME is now up"

# List the deployment and pod ids for this helm release
kubectl get deployments --selector=release=$RELEASE_NAME -o=custom-columns=NAME:.metadata.name
kubectl get po --selector=release=$RELEASE_NAME | grep 'Running' | cut -d ' ' -f 1
echo $RELEASE_NAME