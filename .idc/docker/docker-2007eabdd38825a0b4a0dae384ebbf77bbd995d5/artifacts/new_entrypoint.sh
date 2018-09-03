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
/root/artifacts/server_setup.sh

# Set up the local liberty feature cache
if [ ! -d /root/artifacts/libertyrepocache ] && [ -f /root/artifacts/libertyrepocache.zip ]; then
	echo "Initializing Liberty feature repository cache"
	echo "Extracting Liberty feature cache for $LOGNAME $(date)"
	unzip -qq /root/artifacts/libertyrepocache.zip -d /root/artifacts
    mkdir -p /opt/ibm/wlp/etc
    cp /root/artifacts/repositories.properties /opt/ibm/wlp/etc/repositories.properties
	echo "Finished extracting Liberty feature cache for $LOGNAME $(date)"
fi

if [ -d /root/artifacts/libertyrepocache ]; then
	echo "Liberty feature cache is setup."
fi

# Start the server if it exists
if [ -f $SERVER_XML ];
then 
    echo "Checking for missing runtime features"
    /opt/ibm/wlp/bin/installUtility install --acceptLicense $WLP_USER_DIR/servers/defaultServer/server.xml
    echo "Starting server from $WLP_USER_DIR"
    /opt/ibm/wlp/bin/server start
fi

# Use the server log messages for container logs
tail -F $WLP_USER_DIR/servers/defaultServer/logs/messages.log 2>&1 | grep -v "tail:"
