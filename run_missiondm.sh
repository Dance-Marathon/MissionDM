#!/bin/sh

# Run the missiondm.org website
# Run this after running included setup script if the server has not been setup yet

# Run this with . ./run_missiondm.sh

DIR=$(pwd)

cd $DIR/src/app/webapp
grunt server &

cd $DIR/src/app/missiondm_server
/bin/sh run_missiondm_server.sh &

cd $DIR
