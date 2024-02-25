#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Generates kubectl credentials and contexts for all GKE clusters in the current or given GCP project

This is fast way to get set up in new environments, or even just add any new GKE clusters to your existing \$HOME/.kube/config

If the argument given is 'all', will run for all GCP projects using gcp_foreach_project.sh

WARNING: GCloud SDK switches your kubectl context to the last cluster you get credentials for. This can lead to race conditions between other kubectl scripts if they have not forked and isolated their \$KUBECONFIG. Do not run this while other naive kubectl commands and scripts are running otherwise those non-isolated commands may fire against the wrong kubernetes cluster. See kubectl.sh for more info

See also:

    kubectl.sh             - isolates kube config to fix kubectl commands to the given cluster to prevent race conditions applying kubectl changes to the wrong cluster
    gke_kubectl.sh         - same as above but also gets the credential
    gcp_foreach_project.sh - iterates all locally configured projects, used by the 'all' argument
    aws_kube_creds.sh      - same as this script but for AWS EKS
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

project_id="${1:-}"

if [ -n "${project_id:-}" ]; then
    if [ "$project_id" = all ]; then
        "$srcdir/gcp_foreach_project.sh" "${BASH_SOURCE[0]}"
        exit 0
    else
        export CLOUDSDK_CORE_PROJECT="$project_id"
    fi
fi

gcloud container clusters list --format='value(name,zone)' |
while read -r cluster zone; do
    echo "Getting GKE credentials for cluster '$cluster' in zone '$zone':"
    gcloud container clusters get-credentials "$cluster" --zone "$zone"
    echo
done