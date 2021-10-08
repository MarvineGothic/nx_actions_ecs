#!/bin/bash
IMAGE_TAG=$1
ECR_REGISTRY="435342033141.dkr.ecr.eu-west-1.amazonaws.com"
AWS_REGION="eu-west-1" 
ECR_REPOSITORY="staging/nx-api"
ECS_SERVICE="staging-service-backend"
ECS_CLUSTER="staging-backend"
ECS_TASK_DEFINITION="deployment/task_definition.json"
CONTAINER_NAME="staging-api-container"

DOCKER_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
DOCKER_IMAGE_LATEST="${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

echo "Build api docker image ${DOCKER_IMAGE}"
docker build -t $DOCKER_IMAGE_LATEST -f ./apps/api/Dockerfile .
docker tag $DOCKER_IMAGE_LATEST $DOCKER_IMAGE

echo "Push api docker image to ECR"
docker push $DOCKER_IMAGE_LATEST
docker push $DOCKER_IMAGE

echo "Try to pull image to ECS"
ecs-cli pull --registry-id $ECR_REGISTRY --region $AWS_REGION --verbose --use-fips "${ECR_REPOSITORY}:${IMAGE_TAG}" 

