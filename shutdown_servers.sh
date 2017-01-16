#!/bin/sh

# Kill the running grunt and go servers
# Should be used if you want to quickly take down the servers

kill $(ps aux | grep '[g]runt' | awk '{print $2}')
kill $(ps aux | grep '[/]bin/sh run_missiondm_server.sh' | awk '{print $2}')
kill $(pgrep missiondm_server)