#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GCP services & APIs enabled in the current GCP Project

Can optionally specify a project id using the first argument, otherwise uses currently configured project

$gcp_info_formatting_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

check_bin gcloud

if [ $# -gt 0 ]; then
    project_id="$1"
    shift || :
    export CLOUDSDK_CORE_PROJECT="$project_id"
fi


# Services & APIs Enabled
cat <<EOF
# ============================================================================ #
#                 S e r v i c e s   &   A P I s   E n a b l e d
# ============================================================================ #

EOF

if ! type is_service_enabled &>/dev/null; then
    echo "getting list of all services & APIs (will use this to determine which services to list based on what is enabled)" >&2
    # shellcheck disable=SC1090,SC1091
    . "$srcdir/gcp_service_apis.sh" >/dev/null
    echo >&2
    echo >&2
fi

gcp_info "Services Enabled" gcloud services list --enabled