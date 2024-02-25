#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Prints users MFAs serial numbers to differentiate Virtual vs Hardware MFAs

Virtual MFAs have a SerialNumber in the format:

arn:aws:iam::<account_id>:mfa/<mfa>


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

aws iam list-virtual-mfa-devices |
jq -r '.VirtualMFADevices[] | [.User.UserName, .SerialNumber] | @tsv' |
column -t