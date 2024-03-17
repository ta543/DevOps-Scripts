#!/usr/bin/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$srcdir/lib/aws.sh"

usage_description="
Sets an AWS CloudWatch billing alarm to trigger as soon as you begin incurring any charges

Creates an SNS topic and subscription for the given email address and links it to the above CloudWatch Alarm to email you as soon as your billing charges go over

The alarm is set in the us-east-1 region (N. Virginia in the web console) because that is where the metric billing data accumulates, regardless of which region you actually use


The first argument sets the alert threshold in USD - an alarm is raised once it goes above that amount
The default threshold is 0.00 USD to alert on any charges for safety

The second argument sets the email address to use in an SNS topic to notify you.
If no email is given specified attempts to use the email from your local Git configuration.
If neither is available, shows this usage mesage.

$usage_aws_cli_required
"

usage_args="<threshold_amount_in_USD> [<email_address>]"

help_usage "$@"

threshold="${1:-0.00}"
email="${2:-$(git config user.email || :)}"

region="us-east-1"

sns_topic="AWS_Charges"

if ! [[ "$threshold" =~ ^[[:digit:]]{1,4}(\.[[:digit:]]{1,2})?$ ]]; then
    usage "invalid threshold argument given - must be 0.01 - 9999.99 USD"
fi

if is_blank "$email"; then
    usage "email address not specified and could not determine email from git config"
fi

timestamp "Creating SNS topic to email '$email' in region '$region'"
output="$(aws sns create-topic --name "$sns_topic" --region "$region" --output json)"

sns_topic_arn="$(jq -r '.TopicArn' <<< "$output")"

echo

timestamp "Subscribing email address '$email' to topic '$sns_topic' in region '$region'"
aws sns subscribe --topic-arn "$sns_topic_arn" --protocol email --notification-endpoint "$email" --region "$region"

echo

timestamp "Creating CloudWatch Alarm for AWS charges > $threshold USD in region '$region'"
aws cloudwatch put-metric-alarm --alarm-name "AWS Charges" \
                                --alarm-description "Alerts on AWS charges greater than $threshold USD" \
                                --actions-enabled \
                                --alarm-actions "$sns_topic_arn" \
                                --region "$region" \
                                --namespace "AWS/Billing" \
                                --metric-name "EstimatedCharges" \
                                --dimensions "Name=Currency,Value=USD" \
                                --threshold "$threshold" \
                                --comparison-operator "GreaterThanThreshold" \
                                --statistic Maximum \
                                --period 21600 \
                                --evaluation-periods 1