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

if [ "$HOST_OS" == "windows" ]; then
	OUTPUT_DIR=/tmp/liberty
else
	OUTPUT_DIR=/root/app/mc-target
fi

tail --lines=120 -f $OUTPUT_DIR/liberty/wlp/usr/servers/defaultServer/logs/messages.log
