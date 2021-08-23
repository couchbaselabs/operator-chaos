#!/bin/bash
# Copyright 2021 Couchbase, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file  except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the  License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Simple script to provision a Kubernetes cluster using KIND: https://kind.sigs.k8s.io/
set -eu

# In case you want a different name
CLUSTER_NAME=${CLUSTER_NAME:-couchbase-chaos}
# The server container image to use
SERVER_IMAGE=${SERVER_IMAGE:-couchbase/server:7.0.0}
# The number of KIND nodes to create
NODE_COUNT=${NODE_COUNT:-6}
# The namespace to use
NAMESPACE=${NAMESPACE:-default}

# Delete the old cluster if it exists
kind delete cluster --name="${CLUSTER_NAME}" || true

# Set up KIND cluster with worker nodes based on NODE_COUNT
CLUSTER_CONFIG=$(mktemp)
cat << EOF > "${CLUSTER_CONFIG}"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
EOF
for _ in $(seq "$NODE_COUNT"); do
    cat << EOF >> "${CLUSTER_CONFIG}"
- role: worker
EOF
done

# Create the new cluster
kind create cluster --name="${CLUSTER_NAME}" --config="${CLUSTER_CONFIG}"
rm -f "${CLUSTER_CONFIG}"

# Speed up deployment by pre-loading the server image
docker pull "${SERVER_IMAGE}"
kind load docker-image "${SERVER_IMAGE}" --name="${CLUSTER_NAME}"

echo "Completed cluster creation"
