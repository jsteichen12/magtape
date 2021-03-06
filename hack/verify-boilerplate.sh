#!/usr/bin/env bash

# Copyright 2020 T-Mobile, USA, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Trademark Disclaimer: Neither the name of T-Mobile, USA, Inc. nor the names of
# its contributors may be used to endorse or promote products derived from this
# software without specific prior written permission.
#
# This is based on existing work from the Kubernetes project:
# https://github.com/kubernetes/kubernetes/blob/master/hack/verify-boilerplate.sh

set -o errexit
set -o nounset
set -o pipefail

MAGTAPE_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

boilerDir="${MAGTAPE_ROOT}/hack/boilerplate"
boiler="${boilerDir}/boilerplate.py"

files_need_boilerplate=()
while IFS=$'\n' read -r line; do
  files_need_boilerplate+=( "$line" )
done < <("${boiler}" "$@")

# Run boilerplate check
if [[ ${#files_need_boilerplate[@]} -gt 0 ]]; then
  for file in "${files_need_boilerplate[@]}"; do
    echo "Boilerplate header is wrong for: ${file}" >&2
  done

  exit 1
fi
