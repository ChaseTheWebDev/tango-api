#!/bin/bash
docker build -t tango-api .
docker push tango-api

ssh deploy@$DEPLOY_SERVER << EOF
docker pull tango-api
docker stop tango-api || true
docker rm tango-api || true
docker rmi tango-api:current || true
docker tag tango-api:latest tango-api:current
docker run -d --restart always --name tango-api -p 3000:3000 tango-api:current
EOF
