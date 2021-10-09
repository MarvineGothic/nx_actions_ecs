#!/bin/bash
IMAGE_TAG=$1
ECR_REGISTRY=$2
AWS_REGION="eu-west-1" 
ECR_REPOSITORY="staging/nx-api"
ECS_SERVICE="staging-service-backend"
ECS_CLUSTER="staging-backend"
ECS_TASK_NAME="task-nx-api-1"
ECS_TASK_DEFINITION="deployment/task_definition.json"
CONTAINER_NAME="staging-api-container"

DOCKER_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
DOCKER_IMAGE_LATEST="${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

echo "Build api docker images"
docker build -t $DOCKER_IMAGE_LATEST -f ./apps/api/Dockerfile .
docker tag $DOCKER_IMAGE_LATEST $DOCKER_IMAGE

echo "Push api docker images to ECR"
docker push $DOCKER_IMAGE_LATEST
docker push $DOCKER_IMAGE

echo "Try to pull image to ECS"
expr='.serviceArns[]|select(contains("/'$ECS_SERVICE'-"))|split("/")|.[1]'

echo "Get services"
aws ecs list-services --output json --cluster $ECS_CLUSTER

SNAME=$(aws ecs list-services --output json --cluster $ECS_CLUSTER | jq -r $expr)
if $SNAME == ""; then
    echo "Missing Service ARN for ${ECS_SERVICE}"
    exit 1
fi
echo "Service: ${SNAME}"

echo "Get old task definition"
OLD_TASK_DEF=$(aws ecs describe-task-definition --task-definition $ECS_TASK_NAME --output json)

echo "Create new task definition"
NEW_TASK_DEF=$(echo $OLD_TASK_DEF | jq --arg NDI $DOCKER_IMAGE '.taskDefinition.containerDefinitions[0].image=$NDI')
FINAL_TASK=$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')

echo "Register new task definition"
aws ecs register-task-definition --family $ECS_TASK_NAME --cli-input-json "$(echo $FINAL_TASK)" --memory 2048 || exit 1

echo "Update service"
SUCCESS_UPDATE=$(aws ecs update-service --service $SNAME --task-definition $ECS_TASK_NAME --cluster $ECS_CLUSTER || exit 1)

echo "ECS updated: ${SUCCESS_UPDATE}"


