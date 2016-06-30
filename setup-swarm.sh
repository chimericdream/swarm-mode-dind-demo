#!/bin/sh

## Script to automate setting up of a swarm dind. Arrays are funky and terrible because ash (shell in alpine / dind image) don't support regular arrays.
## John Harris <john@johnharris.io>

## set variables
DAEMON_PORT=2375
SWARM_PORT=2377
PRIMARY_MANAGER=swarm-manager-1:$SWARM_PORT

## initialise the swarm on swarm-manager-1
docker swarm init --auto-accept worker --auto-accept manager

## declare the HA managers
managers=" \
swarm-manager-2 \
swarm-manager-3 \
"

## join the managers to the swarm
for manager in $managers
do
     echo "Configuring $manager ..."
	 export DOCKER_HOST="$manager":$DAEMON_PORT
     docker swarm join --manager $PRIMARY_MANAGER
     sleep 2
done

## declare the worker nodes
workers=" \
swarm-worker-1 \
swarm-worker-2 \
swarm-worker-3 \
swarm-worker-4 \
swarm-worker-5 \
"

## join the work nodes to the swarm
for worker in $workers
do
	echo "Configuring $worker ..."
    export DOCKER_HOST="$worker":$DAEMON_PORT
    docker swarm join $PRIMARY_MANAGER
    sleep 2
done

sleep 2

echo "Setting DOCKER_HOST back to swarm-manager-1 ..."
export DOCKER_HOST=
echo "Listing all swarm nodes ..."
docker node ls
