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
# It then spins up a Couchbase Server cluster on it using Helm: https://helm.sh/
# To use, need Docker (or a container runtime) installed plus kubectl, KIND & Helm.
set -eu

# In case you want a different name
CLUSTER_NAME=${CLUSTER_NAME:-couchbase-chaos}
# The server container image to use
SERVER_IMAGE=${SERVER_IMAGE:-couchbase/server:7.0.0}
# The number of server pods and KIND nodes to create
SERVER_COUNT=${SERVER_COUNT:-3}
# The namespace to use
NAMESPACE=${NAMESPACE:-default}

# Delete the old cluster if it exists
kind delete cluster --name="${CLUSTER_NAME}" || true

# Set up KIND cluster with worker nodes based on SERVER_COUNT
CLUSTER_CONFIG=$(mktemp)
cat << EOF > "${CLUSTER_CONFIG}"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
EOF
for _ in $(seq "$SERVER_COUNT"); do
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

# Add Couchbase via helm chart (depending on whether you include the extra slash or not)
helm repo add couchbase https://couchbase-partners.github.io/helm-charts/ || helm repo add couchbase https://couchbase-partners.github.io/helm-charts
# Ensure we update the repo (may have added it years ago!)
helm repo update
# Install the operator and configure a cluster using the specified server count and image version
# Always installs the latest version of the chart, can be pinned with --version X
helm upgrade --install chaos couchbase/couchbase-operator \
    --set cluster.image="${SERVER_IMAGE}",cluster.servers.default.size="${SERVER_COUNT}" \
    --namespace "${NAMESPACE}" --create-namespace --wait

echo "Completed cluster creation and configuration"