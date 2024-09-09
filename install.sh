#!/usr/bin/env bash

echo "Pulling Docker image..."
docker pull xrsec/awvs:24.4.240427095

echo "Running Docker container..."
docker run -itd --name awvs --cap-add LINUX_IMMUTABLE -p "3443:3443" xrsec/awvs:24.4.240427095

echo "Running commands inside the Docker container..."
docker exec -it awvs /bin/bash -c "
    apt update -y &&
    apt upgrade -y &&
    apt install libsqlite3-dev -y &&
    apt install wget -y &&
    wget https://raw.githubusercontent.com/ngductung/acunetix23/main/check-tools.sh --no-check-certificate &&
    chmod +x check-tools.sh &&
    ./check-tools.sh
"

echo "Script execution finished."