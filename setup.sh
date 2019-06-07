# !/bin/bash
set -e
export ZONE=us-central1-a
echo "ZONE=${ZONE}"
export DOCKER_IMAGE_BASE_NAME=appweb
export KUBERNETES_CLUSTER_NAME_SUFFIX=kb-cluster
