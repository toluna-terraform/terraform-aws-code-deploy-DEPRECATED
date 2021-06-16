
data "aws_iam_policy_document" "codedeploy_role_policy" {
  statement {
    actions   = [
            "ecs:DescribeServices",
            "ecs:CreateTaskSet",
            "ecs:UpdateServicePrimaryTaskSet",
            "ecs:DeleteTaskSet",
            "cloudwatch:DescribeAlarms"
        ]
    # TODO: replace with ecs arn
    resources = ["*"]
  }
  statement {
    actions   = ["sns:Publish"]
    resources = ["arn:aws:sns:*:*:CodeDeployTopic_*"]
  }
  statement {
    actions   = [
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:ModifyRule"
        ]
    resources = ["*"]
  }
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:*:*:function:CodeDeployHook_*"]
  }
  statement {
    actions   = [
        "s3:GetObject",
        "s3:GetObjectVersion"
        ]
    resources = ["*"]
    condition {
        test = "StringEquals"
        variable = "s3:ExistingObjectTag/UseWithCodeDeploy"
        values = ["true"]
    }
  }
  statement {
    actions   = ["iam:PassRole"]
    resources = [
        "arn:aws:iam::*:role/ecsTaskExecutionRole",
        "arn:aws:iam::*:role/ECSTaskExecution*"
        ]
    condition {
    test = "StringLike"
    variable = "iam:PassedToService"
    values = ["ecs-tasks.amazonaws.com"]
    }
  }
}