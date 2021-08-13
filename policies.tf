# The policy document that allows assumption of the provisioner role in
# assessment accounts only.
data "aws_iam_policy_document" "provision_assessment" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Deny"

    resources = formatlist("arn:aws:iam::%s:role/%s", local.non_assessment_account_ids, var.provision_assessment_role_name)

    sid = "DenyNonAssessmentAccounts"
  }

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    # For an extra layer of security, we check that the role has been
    # properly tagged as "AssessmentAccount == true".
    condition {
      test = "StringEquals"
      values = [
        "true",
      ]
      variable = "aws:ResourceTag/AssessmentAccount"
    }

    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/${var.provision_assessment_role_name}",
    ]

    sid = "AllowAssessmentAccounts"
  }
}

# The policy that allows assumption of the provisioner role in assessment
# accounts only.
resource "aws_iam_policy" "provision_assessment" {
  provider = aws.users

  description = var.provision_assessment_policy_description
  name        = var.provision_assessment_policy_name
  policy      = data.aws_iam_policy_document.provision_assessment.json
}
