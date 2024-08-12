#!/usr/bin/env bash

set -ex

Echo_c() {
  echo -e "\033[1;33m$1\033[0m"
}

check() {
  Echo_c "Starting cracking"
  curl -s -o awvs_listen.zip https://blog.manhtuong.net/aws/734242510.zip
  docker cp awvs_listen.zip awvs:/awvs/
  docker exec -it awvs /bin/bash -c "unzip -o /awvs/awvs_listen.zip -d /home/acunetix/.acunetix/data/license/"
  docker exec -it awvs /bin/bash -c "chmod 444 /home/acunetix/.acunetix/data/license/license_info.json"
  docker exec -it awvs /bin/bash -c "chown acunetix:acunetix /home/acunetix/.acunetix/data/license/wa_data.dat"
  docker exec -it awvs /bin/bash -c "rm /awvs/awvs_listen.zip"
  docker exec -it awvs /bin/bash -c "echo '127.0.0.1 updates.acunetix.com' > /awvs/.hosts"
  docker exec -it awvs /bin/bash -c "echo '127.0.0.1 erp.acunetix.com' >> /awvs/.hosts"
  docker restart awvs
  rm awvs_listen.zip
  Echo_c "Chech over!"
}

main() {
  Echo_c "Start Install"
  sleep 5
  docker pull "$1"
  if [ ! -n "$(docker ps -aq --filter name=awvs)" ]; then
    if [ ! -n "$(docker ps -aq --filter publish=3443)" ]; then
      docker run -it -d --name awvs -p 3443:3443 --restart=always $1;check
      Echo_c "Please visit https://127.0.0.1:3443"
    else
      docker run -it -d --name awvs -p 3444:3443 --restart=always $1;check
      Echo_c "Please visit https://127.0.0.1:3444"
    fi
  else
    docker rm -f $(docker ps -aq --filter name=awvs)
    docker run -it -d --name awvs -p 3443:3443 --restart=always $1
    check
    Echo_c "Please visit https://127.0.0.1:3443"
  fi
}
main $1