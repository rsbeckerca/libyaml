#!/bin/bash

DEPLOY_TARGET=$1
DEST=$2
export DEST
BASE_FILE=$3
TARGET_BASE_FILE=$4

set -eo pipefail

DEPLOY_FILE=${BASE_FILE}
TARGET_FILE=${TARGET_BASE_FILE}

echo "******************************************************" && \
echo "*" && \
echo "Deploying ${TARGET_FILE} to $DEST" && \
cp -p "${DEPLOY_FILE}" "${DEST}/${TARGET_FILE}" && \
echo "${TARGET_FILE} deployed to $DEST" && \
echo "******************************************************"
