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

echo
if [ -f $SERVER_XML ]; then
        echo "Checking for missing runtime features for $WLP_USER_DIR/servers/defaultServer $(date)"
        /opt/ibm/wlp/bin/installUtility install --acceptLicense $WLP_USER_DIR/servers/defaultServer/server.xml
        echo "Starting server $WLP_USER_DIR/servers/defaultServer $(date)"
        /opt/ibm/wlp/bin/server start
        echo "Completed $(date)"
else 
	echo Before starting the server, you must first build the project.
fi
echo
