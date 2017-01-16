#!/bin/sh

# Setup and install MissionDM path variables & npm pacakges
# Build go executables for server & make symlinks for webapp to server

# Run '. ./setup.sh' in terminal to execute this correctly to set env variables

DIR=$(pwd)

export GOPATH=$DIR
export ASSPATH=$DIR/src/app/

cd $ASSPATH/webapp/
npm install
grunt prod

cd $ASSPATH/missiondm_server
go build

cd $ASSPATH/missiondm_server/js/
/bin/sh make_symlinks.sh

cd $DIR