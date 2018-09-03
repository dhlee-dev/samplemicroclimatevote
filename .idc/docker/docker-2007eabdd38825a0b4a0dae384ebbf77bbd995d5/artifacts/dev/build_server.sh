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

cd /root/target

mvn liberty:stop-server package liberty:start-server

cd -
