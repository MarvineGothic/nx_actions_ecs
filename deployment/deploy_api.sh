#!/bin/bash
IMAGE_TAG=$1
ECR_REGISTRY=$2
ENV=$3

echo "Check ENV: ${ENV}"
if [ $ENV == "staging" ]; then
    ECR_REPOSITORY="staging/nx-api"
    ECS_CLUSTER="staging-backend"
    ECS_SERVICE="staging-service-backend"
else
    ECR_REPOSITORY="production/nx-api"
    ECS_CLUSTER="production-backend"
    ECS_SERVICE="production-service-backend"
fi

echo "ECR repo: ${ECR_REPOSITORY}"
# DOCKER_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
# DOCKER_IMAGE_LATEST="${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

# echo "Build api docker images"
# docker build -t $DOCKER_IMAGE_LATEST -f ./apps/api/Dockerfile .
# docker tag $DOCKER_IMAGE_LATEST $DOCKER_IMAGE

# echo "Push api docker images to ECR"
# docker push $DOCKER_IMAGE_LATEST
# docker push $DOCKER_IMAGE

# echo "Try to push image to ECS"
# ecs-deploy -c $ECS_CLUSTER -n $ECS_SERVICE -i $DOCKER_IMAGE || exit 1