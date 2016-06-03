#/usr/bin/env bash

PORT=${1:-8080}

printf "Starting application on port %d\n" ${PORT}
$(dirname $0)/gradlew -Dserver.port=${PORT} bootRun >>/dev/null 2>&1 &
BOOTRUN=$!

while ! echo 'GET / HTTP/1.1' | nc localhost ${PORT} </dev/null; do sleep 1; done
echo "Application started."

$(dirname $0)/gradlew pactVerify
EXIT=$?

echo "Tearing down application"
kill ${BOOTRUN}
while echo 'GET / HTTP/1.1' | nc localhost ${PORT} </dev/null; do sleep 1; done

printf "Exiting with status %d\n" ${EXIT}
exit ${EXIT}
