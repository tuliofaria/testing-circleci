# !/bin/bash
set -e
export ZONE=us-central1-a
export DOCKER_IMAGE_BASE_NAME=appweb
export KUBERNETES_CLUSTER_NAME_SUFFIX=kb-cluster
if [ "${CIRCLE_BRANCH}" == "staging" ]; then
  export PROJECT_ID=e2e-staging-242915	
  export PROJECT_NAME=e2e-staging
  export ACCOUNT_ID=${STAGING_ACCOUNT_ID}
  export ACCOUNT_KEY=${STAGING_ACCOUNT_KEY}
fi 

echo "Deploying ${DOCKER_IMAGE_BASE_NAME} to ${CIRCLE_BRANCH}"
echo $ACCOUNT_KEY > service_key.txt
base64 -i service_key.txt -d > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${ACCOUNT_ID} --key-file ${HOME}/gcloud-service-key.json
gcloud config set project e2e-staging-242915
gcloud --quiet config set container/cluster $PROJECT_NAME-$KUBERNETES_CLUSTER_NAME_SUFFIX
gcloud config set compute/zone $ZONE
gcloud --quiet container clusters get-credentials $PROJECT_NAME-$KUBERNETES_CLUSTER_NAME_SUFFIX
docker build -t gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1 .
gcloud docker -- push gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1
echo "deployment/${DOCKER_IMAGE_BASE_NAME} ${DOCKER_IMAGE_BASE_NAME}=gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:${CIRCLE_SHA1}"
kubectl set image deployment/${DOCKER_IMAGE_BASE_NAME} ${DOCKER_IMAGE_BASE_NAME}=gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_BASE_NAME}:$CIRCLE_SHA1
echo " Successfully deployed"
