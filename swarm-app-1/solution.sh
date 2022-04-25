#! /bin/sh

# -- Networks --
docker network create --driver overlay frontend
docker network create --driver overlay backend

# -- Services --
# Vote
docker service create --publish=80:80 --network=frontend --replicas=2 --name=vote  bretfisher/examplevotingapp_vote
# Redis
docker service create --name=redis --network=frontend redis:3.2
# Worker
docker service create --name=worker --network=frontend --network=backend bretfisher/examplevotingapp_worker
# DB
docker service create --name=db --mount type=volume,source=db-data,target=/var/lib/postgresql/data --network=backend --env POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4
# Result
docker service create --name=result --publish=5001:80 --network=backend bretfisher/examplevotingapp_result
