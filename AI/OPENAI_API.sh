#!/usr/bin

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$srcdir/lib/utils.sh"

usage_description="
Queries the OpenAI API

Automatically handles authentication via environment variable \$OPENAI_API_KEY
If a member of multiple organizations then you must also set \$OPENAI_ORGANIZATION_ID

Can specify \$CURL_OPTS for options to pass to curl or provide them as arguments

Examples:


List Models:

    ${0##*/} /models

Retrieve Model:

    ${0##*/} /models/{model_id}

    ${0##*/} /models/gpt-3.5-turbo

List Files in our org:

    ${0##*/} /files

Get File metadata:

    ${0##*/} /files/{file_id}

Get File content:

    ${0##*/} /files/{file_id}/content

List fine-tuning jobs:

    ${0##*/} /fine-tunes

Retrieve fine-tune:

    ${0##*/} /fine-tunes/{fine_tune_id}
"

usage_args="/path [<curl_options>]"

url_base="https://api.openai.com/v1"

help_usage "$@"

min_args 1 "$@"

check_env_defined OPENAI_API_KEY

curl_api_opts "$@"

url_path="$1"
shift || :

url_path="${url_path//https:\\/\\/api.openai.com\/v1}"
url_path="${url_path##/}"

export TOKEN="$OPENAI_API_KEY"

if [ -n "${OPENAI_ORGANIZATION_ID:-}" ]; then
    CURL_OPTS+=(-H "OpenAI-Organization: $OPENAI_ORGANIZATION_ID")
fi

"$srcdir/../bin/curl_auth.sh" "$url_base/$url_path" ${CURL_OPTS:+"${CURL_OPTS[@]}"} "$@" |
jq_debug_pipe_dump