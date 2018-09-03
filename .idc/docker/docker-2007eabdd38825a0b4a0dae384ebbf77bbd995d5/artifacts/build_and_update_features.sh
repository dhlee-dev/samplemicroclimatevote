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

cd /root/artifacts

# The server must be stopped in order to run installUtility
./stop_server.sh
echo

./build_server.sh $LOGNAME $LIBERTY_ENV config
echo

# Start the server back up (and run installUtility)
./start_server.sh
echo
