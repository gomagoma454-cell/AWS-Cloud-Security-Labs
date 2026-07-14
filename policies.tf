data "aws_iam_policy_document" "developer_restrictions" {
  
  # Fix CKV_AWS_111 & CKV_AWS_356: Restrict execution rights to standard dev targets only
  statement {
    sid    = "AllowEC2LifecycleManagement"
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    # Hardened constraint: The user can ONLY affect instances in us-east-1
    resources = ["arn:aws:ec2:us-east-1:*:instance/*"]
  }

  # Read-only actions that do not alter state are allowed globally to avoid breaking functionality
  statement {
    sid    = "AllowEC2GlobalDiscovery"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeImages"
    ]
    resources = ["*"]
  }

  # Explicitly deny structural network access to stop structural bypasses
  statement {
    sid    = "DenyNetworkModifications"
    effect = "Deny"
    actions = [
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dev_least_privilege" {
  name        = "Developer-Least-Privilege-Policy"
  description = "Granular execution rights with network isolation constraints"
  policy      = data_aws_iam_policy_document.developer_restrictions.json
}

# Attach our secure policy structure directly to our new assumed role
resource "aws_iam_role_policy_attachment" "attach_dev_policy" {
  role       = aws_iam_role.developer_role.name
  policy_arn = aws_iam_policy.dev_least_privilege.arn
}
