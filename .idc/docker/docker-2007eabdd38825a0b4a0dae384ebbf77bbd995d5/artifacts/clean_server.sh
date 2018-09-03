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
LOGNAME=$1
LIBERTY_ENV=$2

source /root/artifacts/envvars.sh

export JAVA_HOME=/root/java

cd /root/artifacts
./stop_server.sh

cd /root/app

if [ "$HOST_OS" == "windows" ]; then
	OUTPUT_DIR=/tmp/liberty
else
	OUTPUT_DIR=`pwd`/mc-target
fi

mvn clean -DlibertyEnv=microclimate -DmicroclimateOutputDir=$OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log
