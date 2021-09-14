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

# Simple script to deploy Litmus using helm.
set -eu

# The namespace to use
NAMESPACE=${NAMESPACE:-litmus}

echo "Deploying Litmus into: $NAMESPACE"
# Install Litmus operator using helm
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/ || helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm
helm repo update
helm install chaos litmuschaos/litmus --namespace="${NAMESPACE}" --create-namespace --wait
echo "Completed Litmus deployment"

# https://docs.litmuschaos.io/docs/getting-started/installation#verify-your-installation
echo "Default credentials for litmus on http://localhost:8080"
echo "Username: admin"
echo "Password: litmus"
# For KIND we need to port forward
kubectl port-forward deploy/chaos-litmus-frontend --namespace="${NAMESPACE}" 8080:8080
