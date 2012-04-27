#!/bin/bash

# Make log directory
mkdir -p ./rel/logs/

# Start each node
./rel/dev1/bin/bigcouch > ./rel/logs/bigcouch1.log 2>&1 &
DB1_PID=$!

./rel/dev2/bin/bigcouch > ./rel/logs/bigcouch2.log 2>&1 &
DB2_PID=$!

./rel/dev3/bin/bigcouch > ./rel/logs/bigcouch3.log 2>&1 &
DB3_PID=$!

/usr/local/sbin/haproxy -f rel/haproxy.cfg > ./rel/logs/haproxy.log 2>&1 &
HP_PID=$!

sleep 2

# Connect the cluster
curl -s localhost:15986/nodes/dev2@127.0.0.1 -X PUT -d '{}' > /dev/null 2>&1
curl -s localhost:15986/nodes/dev3@127.0.0.1 -X PUT -d '{}' > /dev/null 2>&1
curl -s localhost:5984/_membership | python -m json.tool


trap "kill $DB1_PID $DB2_PID $DB3_PID $HP_PID" SIGINT SIGTERM SIGHUP

wait
