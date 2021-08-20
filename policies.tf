# The policy document that allows assumption of all roles needed in order to
# provision assessment environments.  It also specifically denies assumption
# of non-required non-assessment account provisioning roles.
data "aws_iam_policy_document" "provision_assessment" {
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

    sid = "AllowAssessmentAccountRoles"
  }

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Allow"

    resources = local.required_non_assessment_roles

    sid = "AllowRequiredNonAssessmentAccountRoles"
  }

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Deny"

    resources = local.prohibited_non_assessment_provision_roles

    sid = "DenyNonAssessmentAccountRoles"
  }
}

# The policy that allows assumption of all roles needed in order to provision
# assessment environments.
resource "aws_iam_policy" "provision_assessment" {
  provider = aws.users

  description = var.provision_assessment_policy_description
  name        = var.provision_assessment_policy_name
  policy      = data.aws_iam_policy_document.provision_assessment.json
}
