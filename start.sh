/opt/janus/bin/janus & # your first application
P1=$!
cd html && python -m http.server 8001 & # your second application
P2=$!
wait $P1 $P2