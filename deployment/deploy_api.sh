#!/bin/bash
SHA=$1
ECR_REGISTRY=$2
AWS_REGION="eu-west-1" 
ECR_REPOSITORY="staging/nx-api"
ECS_SERVICE="staging-service-backend"
ECS_CLUSTER="staging-backend"
ECS_TASK_DEFINITION="deployment/task_definition.json"
CONTAINER_NAME="staging-api-container"

DOCKER_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
DOCKER_IMAGE_LATEST="${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

echo "Build api docker image ${SECRET_KEY} ${REGION}"
docker build -f ../apps/api/Dockerfile -t .
docker build -t $DOCKER_IMAGE_LATEST -f ../apps/api/Dockerfile .
docker tag $DOCKER_IMAGE_LATEST $DOCKER_IMAGE
docker push $DOCKER_IMAGE_LATEST
docker push $DOCKER_IMAGE

