#!/bin/sh
set -e
TEST_DIR=$(mktemp -d)
cd "${TEST_DIR}" || exit 1
git clone https://github.com/kubernetes/cloud-provider-vsphere .
hack/make.sh

VERSION=$(git describe --match=$(git rev-parse --short=8 HEAD) --always --dirty --abbrev=8)
cp vsphere-cloud-controller-manager cluster/images/controller-manager
docker build -t ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION} cluster/images/controller-manager
docker tag ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION} ${REGISTRY}/vsphere-cloud-controller-manager:latest
docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";
docker push ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION}
docker push ${REGISTRY}/vsphere-cloud-controller-manager:latest
echo ${VERSION}

rm -rf ${TEST_DIR}
