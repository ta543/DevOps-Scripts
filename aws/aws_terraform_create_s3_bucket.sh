#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates an S3 bucket for storing Terraform state with the following optimizations:

- Enables Versioning
- Enables Encryption
- Enables Versioning
- Enables Server Side Encryption
- Creates Bucket Policy to lock out:
  - Power Users role
  - any additional given user/group/role ARNs (optional)

Idempotent: skips bucket creation if already exists, applies versioning, encryption, and applies bucket policy if none exists of if \$OVERWRITE_BUCKET_POLICY is set to any value

Region: will create the bucket in your configured region, to override locally set \$AWS_DEFAULT_REGION


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<bucket_name> [<ARNs_to_block_access_from>]"

help_usage "$@"

min_args 1 "$@"

bucket="$1"
shift || :

timestamp "Checking for Power User role"
power_user_arn="$(aws iam list-roles | jq -r '.Roles[].Arn' | grep -i AWSPowerUserAccess || :)"
if [ -n "$power_user_arn" ]; then
    timestamp "Power User role ARN found:  $power_user_arn"
fi
echo >&2

"$srcdir/aws_s3_bucket.sh" "$bucket" "$@" ${power_user_arn:+"$power_user_arn"}