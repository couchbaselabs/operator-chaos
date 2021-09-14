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

# Simple script to deploy ChaosMesh: https://chaos-mesh.org/docs/quick-start/
# Assumes deployed Kubernetes cluster already
set -eu

CLUSTER_NAME=${CLUSTER_NAME:-couchbase-chaos}
# The namespace to use
NAMESPACE=${NAMESPACE:-chaos-testing}

echo "Deploying ChaosMesh into: $NAMESPACE"

# Remove any existing deployment
kubectl delete ns "$NAMESPACE" || true
curl -sSL https://mirrors.chaos-mesh.org/v2.0.1/install.sh | bash -s -- --local kind --name "${CLUSTER_NAME}" --namespace "$NAMESPACE"

echo "Completed ChaosMesh deployment"

# https://chaos-mesh.org/docs/quick-start/
kubectl port-forward -n "$NAMESPACE" svc/chaos-dashboard 2333:2333