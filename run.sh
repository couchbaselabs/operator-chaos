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

set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set this to chaosblade, chaosmesh or litmus depending on which one you want.
# Set it to "all" to deploy them all in a single cluster.
CHAOS_TOOL_TO_USE=${CHAOS_TOOL_TO_USE:-chaosmesh}

/bin/bash "${SCRIPT_DIR}/tools/create-cluster.sh"

if [[ "${CHAOS_TOOL_TO_USE}" == "all" ]]; then
    echo "Deploying all Chaos tools"
    for i in "${SCRIPT_DIR}"/tools/deploy-*.sh; do
        # Ignore invalid/non-files
        [[ ! -f "$i" ]] && continue
        /bin/bash "${i}"
    done
else
    echo "Deploying single Chaos tool: $CHAOS_TOOL_TO_USE"
    /bin/bash "${SCRIPT_DIR}/tools/deploy-$CHAOS_TOOL_TO_USE.sh"
    /bin/bash "${SCRIPT_DIR}/tools/deploy-couchbase.sh"
fi
