#!/bin/sh

# Reset the database by clearing all teams and previous participants
# Uses the refresh.sql file included in the databases/ directory

/etc/init.d/postgresql reload
psql -h localhost -U postgres -c "DROP DATABASE missiondm"
psql -h localhost -U postgres -c "CREATE DATABASE missiondm"
psql -h localhost -d missiondm -U postgres -f $DIR/src/app/database/refresh.sql
