until ./missiondm_server; do
    echo "Server 'missiondm_server' crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
