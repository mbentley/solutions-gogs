mbentley/solutions-gogs
=======================

Gogs image with pre-configured git repo w/webhook

Basic service usage:
```
docker service create \
  --detach \
  --replicas 1 \
  --constraint "node.hostname == ${PROJECT}_docker1" \
  --mount type=volume,source=gogs-data,destination=/data,readonly=false \
  --network ucp-hrm \
  --label "com.docker.ucp.mesh.http.3000=internal_port=3000,external_route=http://gogs.${DOMAIN_NAME}" \
  --name gogs \
  mbentley/solutions-gogs:latest
```
