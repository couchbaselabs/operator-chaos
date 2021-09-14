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

# Simple script to deploy ChaosBlade
set -eu

# The namespace to use
NAMESPACE=${NAMESPACE:-chaosblade}

echo "Deploying ChaosBlade into: $NAMESPACE"

# Have to get helm chart from repo:
HELM_CHART_DIR=$(mktemp -d)
pushd "${HELM_CHART_DIR}"
wget https://github.com/chaosblade-io/chaosblade-operator/releases/download/v1.3.0/chaosblade-operator-1.3.0-v3.tgz
# Now install from the tarball
helm install chaosblade-operator chaosblade-operator-1.3.0-v3.tgz --namespace "${NAMESPACE}" --create-namespace --wait
popd
# Clean up the tarball
rm -rf "${HELM_CHART_DIR}"
echo "Completed ChaosBlade deployment"

kubectl get pods --namespace "${NAMESPACE}"
# https://github.com/chaosblade-io/chaosblade-operator