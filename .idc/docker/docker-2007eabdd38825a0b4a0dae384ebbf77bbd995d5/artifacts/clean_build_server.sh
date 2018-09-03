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

./stop_server.sh
echo

./clean_server.sh $LOGNAME $LIBERTY_ENV
echo

./build_server.sh $LOGNAME $LIBERTY_ENV
echo

./start_server.sh
echo
