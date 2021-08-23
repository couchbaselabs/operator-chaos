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

# The namespace to use
NAMESPACE=${NAMESPACE:-litmus}

# Install Litmus operator using helm
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/ || helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm
helm repo update
helm install chaos litmuschaos/litmus --namespace="${NAMESPACE}" --create-namespace --wait

echo "Completed Litmus deployment"
