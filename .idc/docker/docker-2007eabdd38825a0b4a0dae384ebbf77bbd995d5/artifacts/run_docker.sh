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

if [ "$#" -lt 4 ]; then
	echo "* First argument should be the container name, the second should be the container id name, the third should be port mapping, the fourth is the idc docker base directory location"
 	exit 1
fi

export CONTAINER_NAME=$1

export CONTAINER_IMAGE_NAME=$2

export PORT_MAPPING_PARAMS="$3"

export IDC_APP_BASE=$4

export MICROCLIMATE_WS_ORIGIN=$5

# The directory that contains this shell script (which is also the installation artifact/ dir)
export ARTIFACTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# App dir
export APPDIR=`pwd`

export APPNAME=$(dirname $APPDIR)

export LOGSDIR=$ARTIFACTS/.logs

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

if [[ $MICROCLIMATE_WS_ORIGIN &&  $APPDIR == '/microclimate-workspace'* ]]
    then
		echo "Running microclimate app container for $APPDIR using container name $CONTAINER_NAME";
		
		# The main MicroProfile directory is the parent of the microclimate workspace
		MICROCLIMATE_ORIGIN_DIR=${MICROCLIMATE_WS_ORIGIN%'/microclimate-workspace'}

		# The app directory is originally in the format /microclimate-workspace/<app name>
		APPDIR=$MICROCLIMATE_ORIGIN_DIR$APPDIR

		# The artifacts directory is in the main microprofile directory
		ARTIFACTS=$MICROCLIMATE_ORIGIN_DIR/docker/file-watcher/idc/artifacts

		LOGSDIR=$MICROCLIMATE_WS_ORIGIN/.logs

		docker run -dt \
		--name $CONTAINER_NAME \
		--network=microclimate_network \
		-v $APPDIR:/root/app \
		-v $LOGSDIR:/root/logs \
		$PORT_MAPPING_PARAMS \
		$CONTAINER_IMAGE_NAME

	else
		docker run -dt \
		--name $CONTAINER_NAME \
		-v $APPDIR:/root/app \
		-v $LOGSDIR:/root/logs \
		$PORT_MAPPING_PARAMS \
		$CONTAINER_IMAGE_NAME

fi
