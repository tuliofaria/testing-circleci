# !/bin/bash
set -e
echo "Deploying ${DOCKER_IMAGE_BASE_NAME} to ${CIRCLE_BRANCH}"
echo $STAGING_ACCOUNT_KEY > service_key.txt
base64 -i service_key.txt -d > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${STAGING_ACCOUNT_ID} --key-file ${HOME}/gcloud-service-key.json
gcloud config set project e2e-staging-242915
gcloud --quiet config set container/cluster $PROJECT_NAME-$KUBERNETES_CLUSTER_NAME_SUFFIX
gcloud config set compute/zone $ZONE
gcloud --quiet container clusters get-credentials $PROJECT_NAME-$KUBERNETES_CLUSTER_NAME_SUFFIX
docker build -t gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1 .
gcloud docker -- push gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1
echo "deployment/${DOCKER_IMAGE_BASE_NAME} ${DOCKER_IMAGE_BASE_NAME}=gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:${CIRCLE_SHA1}"
kubectl set image deployment/${DOCKER_IMAGE_BASE_NAME} ${DOCKER_IMAGE_BASE_NAME}=gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1
echo " Successfully deployed"
