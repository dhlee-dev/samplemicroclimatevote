@echo off
REM #*******************************************************************************
REM # Licensed Materials - Property of IBM
REM # "Restricted Materials of IBM"
REM #
REM # Copyright IBM Corp. 2018 All Rights Reserved
REM #
REM # US Government Users Restricted Rights - Use, duplication or disclosure
REM # restricted by GSA ADP Schedule Contract with IBM Corp.
REM #*******************************************************************************

SET argCount=0
for %%x in (%*) do SET /A argCount+=1

if %argCount% LSS 4 (
	echo * First argument should be the container name, the second should be the container id, the third should be port mapping, the fourth is the idc docker base directory location
	EXIT /B 1
)

SET CONTAINER_NAME=%1
SET CONTAINER_IMAGE_NAME=%2
SET PORT_MAPPING_PARAMS=%~3
SET IDC_APP_BASE=%4
SET MICROCLIMATE_WS_ORIGIN=%5

SET ARTIFACTS=%~dp0.

SET APPDIR=%cd%

SET LOGSDIR=%ARTIFACTS%/.logs

docker stop %CONTAINER_NAME%
docker rm %CONTAINER_NAME%

docker run -dt --name %CONTAINER_NAME% -v %APPDIR%:/root/app -v %LOGSDIR%:/root/logs %PORT_MAPPING_PARAMS% %CONTAINER_IMAGE_NAME%
