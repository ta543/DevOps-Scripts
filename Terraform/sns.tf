
# XXX: global search and replace 'NAME'
resource "aws_sns_topic" "NAME" {
  name = "NAME"
}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic_policy" "NAME" {
  arn    = aws_sns_topic.NAME.arn
  policy = data.aws_iam_policy_document.NAME-sns-topic-policy.json
}

data "aws_iam_policy_document" "aws-charges-sns-topic-policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        #var.account-id,
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.NAME.arn,
    ]
  }

  statement {
    sid = "NAME-notification"
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["*.amazonaws.com"] # XXX: tighten to expected service
    }

    resources = [
      aws_sns_topic.NAME.arn,
    ]
  }
}

resource "aws_sns_topic_subscription" "NAME" {
  topic_arn = aws_sns_topic.NAME.arn
  protocol  = "email"
  endpoint  = var.email
  lifecycle {
    ignore_changes = [pending_confirmation]
  }
}

data "aws_sns_topic" "NAME" {
  name       = "NAME"
  depends_on = [aws_sns_topic.NAME]
}
