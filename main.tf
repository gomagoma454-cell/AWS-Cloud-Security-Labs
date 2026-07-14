# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 1. Define the Trust Policy using a clean data document (Fixes CKV_AWS_61 parsing)
data "aws_iam_policy_document" "role_trust_policy" {
  statement {
    sid     = "AllowTrustedAccountAssumption"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }
  }
}

# 2. Create the IAM Role and reference the data block above
resource "aws_iam_role" "developer_role" {
  name               = "Engineering-Developer-Role"
  description        = "Temporary execution role for internal application developers"
  assume_role_policy = data.aws_iam_policy_document.role_trust_policy.json
}
