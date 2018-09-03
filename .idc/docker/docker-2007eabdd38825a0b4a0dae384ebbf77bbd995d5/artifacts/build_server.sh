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

source /root/artifacts/envvars.sh

LOGNAME=$1
LIBERTY_ENV=$2

# Maven requires a JDK, the standard liberty image only includes a JRE
export JAVA_HOME=/root/java

# If the local m2 repository doesn't exist and a local dependency cache exists then prime it before the build
if [ ! -d /root/.m2/repository ] && [ -f /root/artifacts/localm2cache.zip ]; then
	echo "Initializing container m2 cache"
	echo "Extracting m2 cache for $LOGNAME $(date)"
	unzip -qq /root/artifacts/localm2cache.zip -d /root/
	echo "Finished extracting m2 cache for $LOGNAME $(date)"

	# Verify m2 cache was set up
	if [ -d /root/.m2/repository ]; then
		echo "m2 cache is set up for $LOGNAME"
	fi

fi

cd /root/app

if [ "$HOST_OS" == "windows" ]; then
	export MICROCLIMATE_OUTPUT_DIR=/tmp/liberty
else
	export MICROCLIMATE_OUTPUT_DIR=`pwd`/mc-target
fi
echo "Maven build output directory is set to $MICROCLIMATE_OUTPUT_DIR"

if [[ $1 && $1 == "prod" ]]; then
	echo "Start mvn package for production"
	echo "mvn -B package -DinstallDirectory=/opt/ibm/wlp"
	mvn -B package -DinstallDirectory=/opt/ibm/wlp
	exit 0	
fi 

if [ -f $SERVER_XML ]; then
	if [[ $3 && $3 == "config" ]]; then
		echo "Start mvn build with config change for $LOGNAME $(date)"
        echo "mvn -B package liberty:install-apps -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log"
        mvn -B package liberty:install-apps -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log
		echo "Finished mvn build with config change for $LOGNAME $(date)"
	else
		echo "Start mvn compile for $LOGNAME $(date)"
        echo "mvn -B compile -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log"
        mvn -B compile -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log
		echo "Finished mvn compile for $LOGNAME $(date)"
	fi
else
	echo "Start mvn package for $LOGNAME $(date)"
    echo "mvn -B package -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log"
    mvn -B package -DskipTests=true -DlibertyEnv=microclimate -DmicroclimateOutputDir=$MICROCLIMATE_OUTPUT_DIR --log-file /root/logs/$LOGNAME.build.log
	echo "Finished mvn package for $LOGNAME $(date)"
fi

