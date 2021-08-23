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
# The number of server pods to create
SERVER_COUNT=${SERVER_COUNT:-3}
# The namespaces to use
DAC_NAMESPACE=${DAC_NAMESPACE:-couchbase-dac}
declare -a TEST_NAMESPACES=("couchbase-test1" "couchbase-test2" "couchbase-test3")

# Add Couchbase via helm chart (depending on whether you include the extra slash or not)
helm repo add couchbase https://couchbase-partners.github.io/helm-charts/ || helm repo add couchbase https://couchbase-partners.github.io/helm-charts
# Ensure we update the repo (may have added it years ago!)
helm repo update

# Only install the DAC once
helm upgrade --install couchbase-dac couchbase/couchbase-operator --set install.couchbaseOperator=false,install.couchbaseCluster=false \
    --namespace "${DAC_NAMESPACE}" --create-namespace --wait

for NAMESPACE in "${TEST_NAMESPACES[@]}"; do
    echo "Deploying ${SERVER_COUNT} Couchbase pods into: $NAMESPACE"
    # Install the operator and configure a cluster using the specified server count and image version
    # Always installs the latest version of the chart, can be pinned with --version X
    helm upgrade --install "${NAMESPACE}" couchbase/couchbase-operator \
        --set cluster.image="${SERVER_IMAGE}",cluster.servers.default.size="${SERVER_COUNT}",install.admissionController=false \
        --namespace "${NAMESPACE}" --create-namespace --wait

    # Wait for deployment to complete, a call to --wait may work with helm but it can be flakey
    echo "Waiting for Couchbase to start up..."
    # The operator uses readiness gates to hold the containers until the cluster is actually ready to be used
    until [[ $(kubectl get pods --namespace "${NAMESPACE}" --field-selector=status.phase=Running --selector='app=couchbase' --no-headers 2>/dev/null |wc -l) -eq $SERVER_COUNT ]]; do
        echo -n '.'
        sleep 2
    done
    echo "Completed Couchbase deployment into: $NAMESPACE"
done