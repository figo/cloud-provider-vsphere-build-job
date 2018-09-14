#!/bin/sh
set -e
TEST_DIR=$(mktemp -d)
cd "${TEST_DIR}" || exit 1
git clone https://github.com/kubernetes/cloud-provider-vsphere.git
cd cloud-provider-vsphere || exit 1
hack/make.sh

VERSION=$(git describe --match=$(git rev-parse --short=8 HEAD) --always --dirty --abbrev=8)
cp vsphere-cloud-controller-manager cluster/images/controller-manager
/usr/bin/docker build --tag ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION} cluster/images/controller-manager
/usr/bin/docker tag ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION} ${REGISTRY}/vsphere-cloud-controller-manager:latest
/usr/bin/docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";
/usr/bin/docker push ${REGISTRY}/vsphere-cloud-controller-manager:${VERSION}
/usr/bin/docker push ${REGISTRY}/vsphere-cloud-controller-manager:latest
echo ${VERSION}
