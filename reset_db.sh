#!/bin/sh

# Reset the database by clearing all teams and previous participants
# Uses the refresh.sql file included in the databases/ directory
DIR=$(pwd)
/etc/init.d/postgresql reset
psql -h localhost -U postgres -c "DROP DATABASE missiondm"
psql -h localhost -U postgres -c "CREATE DATABASE missiondm"
psql -h localhost -d missiondm -U postgres -f $DIR/src/app/database/refresh.sql
/etc/init.d/postgresql reload
