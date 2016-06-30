#!/bin/sh

docker-compose up -d
sleep 5
docker-compose exec swarm-manager-1 ./setup-swarm.sh
docker exec -it swarm-manager-1 sh
