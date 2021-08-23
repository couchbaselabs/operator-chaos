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

# Simple script to spin up a Couchbase Server cluster using Helm: https://helm.sh/
set -eu

# The server container image to use
SERVER_IMAGE=${SERVER_IMAGE:-couchbase/server:7.0.0}
# The number of server pods and KIND nodes to create
SERVER_COUNT=${SERVER_COUNT:-3}
# The namespace to use
NAMESPACE=${NAMESPACE:-default}

echo "Deploying Couchbase into: $NAMESPACE"
# Add Couchbase via helm chart (depending on whether you include the extra slash or not)
helm repo add couchbase https://couchbase-partners.github.io/helm-charts/ || helm repo add couchbase https://couchbase-partners.github.io/helm-charts
# Ensure we update the repo (may have added it years ago!)
helm repo update
# Install the operator and configure a cluster using the specified server count and image version
# Always installs the latest version of the chart, can be pinned with --version X
helm upgrade --install chaos couchbase/couchbase-operator \
    --set cluster.image="${SERVER_IMAGE}",cluster.servers.default.size="${SERVER_COUNT}" \
    --namespace "${NAMESPACE}" --create-namespace --wait

echo "Completed Couchbase deployment"
