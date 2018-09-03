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

if [ -f $SERVER_XML ]; then
        /opt/ibm/wlp/bin/server stop
else
	echo The server is not started. $SERVER_XML does not exist.
fi

echo
