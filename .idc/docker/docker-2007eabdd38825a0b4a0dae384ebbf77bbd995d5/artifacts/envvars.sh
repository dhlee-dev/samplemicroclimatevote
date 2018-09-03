export HOST_OS=windows
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

if [ "$HOST_OS" == "windows" ]; then
        export WLP_USER_DIR=/tmp/liberty/liberty/wlp/usr
else
        export WLP_USER_DIR=/root/app/mc-target/liberty/wlp/usr
fi
export SERVER_XML=$WLP_USER_DIR/servers/defaultServer/server.xml

export LOG_DIR=
export WLP_OUTPUT_DIR=
