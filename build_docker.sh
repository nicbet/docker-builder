#!/bin/bash
set -eu

# ----------------------------------------------------------------------
# ASSEMBLE BUILD META-DATA
# ----------------------------------------------------------------------

# What is the origin's repo name
GIT_ORIGIN_REPO_NAME=`basename $(git remote show -n origin | grep Fetch | cut -d: -f2- | sed -e 's/.git$//g')`

# Calculate seconds from Midnight
SECONDS=$((`date +%s` % 86400))

# Calculate a date timestamp
YMD=`date +%Y.%m%d`

# Calculate a shortened commit hash
COMMITHASH=`git log --pretty=format:'%h' -n 1`

# Resolve the current branch we are on
BRANCH=`git symbolic-ref --short -q HEAD | sed -e 's#/#-#g'`

# Use build number from bamboo if it is set, "0" otherwise
BUILD_NUMBER=${bamboo_buildNumber:-"0"}

# Use BUILD environment variable if set, the BUILD_NUMBER otherwise
# (which is either the build number set by Bamboo or the default of "0")
BUILD=${BUILD:-${BUILD_NUMBER}}

# Semantic Version Tag
# example tag: 2018.0713.56722_0.master.64f119c
META_TAG=${YMD}.${SECONDS}_${BUILD}.${COMMITHASH}

# ----------------------------------------------------------------------
# USE BUILD META-DATA TO GENERATE IMAGE NAME
# ----------------------------------------------------------------------

# If DOCKER_REGISTRY is set, use that value, otherwise default to '/nicbet'
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"nicbet/"}

# If DOCKER_IMAGE NAME is set, use that value, otherwise default to the origin repo name
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-${GIT_ORIGIN_REPO_NAME}}

# Concat Meta-Data to create a tag
DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG:-${META_TAG}}

# Concat Repo, Image Name and Tag for a fully qualified image name
DOCKER_IMAGE_FQN=${DOCKER_REGISTRY}${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}


# ----------------------------------------------------------------------
# RUN DOCKER BUILD COMMAND
# ----------------------------------------------------------------------

echo "Building ${DOCKER_IMAGE_FQN} ..."
docker build -t ${DOCKER_IMAGE_FQN} .
