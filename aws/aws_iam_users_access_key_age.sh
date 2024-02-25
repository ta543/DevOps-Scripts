#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Prints users access key status and age

See Also:

    aws_iam_users_access_key_age_report.sh - much quicker version for lots of users


    aws_users_access_key_age.py - in DevOps Python Tools which is able to filter by age and status

    https://github.com/HariSekhon/DevOps-Python-tools


    awless list accesskeys --format tsv | grep 'years[[:space:]]*$'


AWS Config rule compliance:

    https://<region>.console.aws.amazon.com/config/home?region=<region>&v2=true#/rules/details?configRuleName=access-keys-rotated

eg.

    https://eu-west-1.console.aws.amazon.com/config/home?region=eu-west-1&v2=true#/rules/details?configRuleName=access-keys-rotated


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

echo "output will be formatted in to columns at end" >&2
echo "getting user list" >&2
aws iam list-users |
jq -r '.Users[].UserName' |
while read -r username; do
    echo "querying user $username" >&2
    aws iam list-access-keys --user-name "$username" |
    jq -r '.AccessKeyMetadata[] | [.UserName, .Status, .CreateDate, .AccessKeyId] | @tsv'
done |
column -t