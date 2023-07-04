#!/bin/sh

echo "$(date +"%F %T"): Waiting for Mysql Service ..."
until nc -zv -w1 ${DB_HOST} ${DB_PORT} &> /dev/null; do
	echo "."
	sleep 5
done
echo "$(date +"%F %T"): Mysql Service is Ready"
echo "$(date +"%F %T"): Starting FreeRadius Service ..."
radiusd -X