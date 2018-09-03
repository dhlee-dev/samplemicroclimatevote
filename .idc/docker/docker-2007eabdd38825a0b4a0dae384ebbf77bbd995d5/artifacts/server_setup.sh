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

if [[ -f $WLP_USER_DIR/servers/defaultServer/server.xml && ! -f /config/server.xml ]]; then
    # If the config files aren't in /config/ then create a symbolic link from the target to /config/ so that
    # the resources will be available when starting the server
    ln -s $WLP_USER_DIR/servers/defaultServer/* /config/
fi

if [[ -f $WLP_USER_DIR/servers/defaultServer/resources/javametrics-agent.jar && ! -f /config/resources/javametrics-agent.jar ]]; then
    # If the config resource files aren't in /config/resources then create a symbolic link from the target to /config/resources so that
    # the resources will be available when starting the server
    ln -s $WLP_USER_DIR/servers/defaultServer/resources/* /config/resources
fi
