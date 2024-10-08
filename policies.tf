# The policy document that allows assumption of the assessment roles
# needed in order to provision assessment environments.
data "aws_iam_policy_document" "provision_assessment_base" {
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
      "arn:aws:iam::*:role/${var.startstopssmsession_role_name}",
    ]

    sid = "AllowAssessmentAccountRoles"
  }
}

# The policy document that allows assumption of all non-assessment
# roles needed in order to provision assessment environments.  It also
# specifically denies assumption of non-required non-assessment
# account provisioning roles.
data "aws_iam_policy_document" "provision_assessment_backend" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Allow"

    resources = local.required_non_assessment_roles_backend

    sid = "AllowRequiredNonAssessmentAccountRoles"
  }

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Deny"

    resources = local.prohibited_non_assessment_roles_backend

    sid = "DenyNonAssessmentAccountRoles"
  }
}

# The policy document that allows assumption of all non-assessment
# roles needed in order to provision assessment environments with the
# exception of Terraform backend access.  It also specifically denies
# assumption of non-required non-assessment account provisioning
# roles.
data "aws_iam_policy_document" "provision_assessment_no_backend" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Allow"

    resources = local.required_non_assessment_roles_no_backend

    sid = "AllowRequiredNonAssessmentAccountRolesNoBackend"
  }

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Deny"

    resources = local.prohibited_non_assessment_roles_no_backend

    sid = "DenyNonAssessmentAccountRolesNoBackend"
  }
}

# The policy that allows assumption of all assessment roles needed in
# order to provision assessment environments.
resource "aws_iam_policy" "provision_assessment_base" {
  provider = aws.users

  description = var.provision_assessment_base_policy_description
  name        = var.provision_assessment_base_policy_name
  policy      = data.aws_iam_policy_document.provision_assessment_base.json
}

# The policy that allows assumption of all non-assessment roles needed
# in order to provision assessment environments.
resource "aws_iam_policy" "provision_assessment_backend" {
  provider = aws.users

  description = var.provision_assessment_backend_policy_description
  name        = var.provision_assessment_backend_policy_name
  policy      = data.aws_iam_policy_document.provision_assessment_backend.json
}

# The policy that allows assumption of all non-assessment roles needed
# in order to provision assessment environments with the exception of
# Terraform backend access.
resource "aws_iam_policy" "provision_assessment_no_backend" {
  provider = aws.users

  description = var.provision_assessment_no_backend_policy_description
  name        = var.provision_assessment_no_backend_policy_name
  policy      = data.aws_iam_policy_document.provision_assessment_no_backend.json
}
