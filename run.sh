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
CHAOS_TOOL_TO_USE=${CHAOS_TOOL_TO_USE:-chaosmesh}

/bin/bash "${SCRIPT_DIR}/tools/create-cluster.sh"
/bin/bash "${SCRIPT_DIR}/tools/deploy-couchbase.sh"
/bin/bash "${SCRIPT_DIR}/tools/deploy-$CHAOS_TOOL_TO_USE.sh"
