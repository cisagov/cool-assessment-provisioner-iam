# An IAM group for assessment environment provisioners.
resource "aws_iam_group" "assessment_provisioners" {
  provider = aws.users

  name = var.assessment_provisioners_group_name
}

# Attach the policy that allows assumption of all assessment roles
# needed in order to provision assessment environments.
resource "aws_iam_group_policy_attachment" "assessment_provisioners_base" {
  provider = aws.users

  group      = aws_iam_group.assessment_provisioners.name
  policy_arn = aws_iam_policy.provision_assessment_base.arn
}

# Attach the policy that allows assumption of all non-assessment roles
# needed in order to provision assessment environments.
resource "aws_iam_group_policy_attachment" "assessment_provisioners_backend" {
  provider = aws.users

  group      = aws_iam_group.assessment_provisioners.name
  policy_arn = aws_iam_policy.provision_assessment_backend.arn
}

# An IAM group for assessment environment provisioners without general
# access to the Terraform backend.
resource "aws_iam_group" "assessment_provisioners_no_backend" {
  provider = aws.users

  name = var.assessment_provisioners_no_backend_group_name
}

# Attach the policy that allows assumption of all assessment roles
# needed in order to provision assessment environments.
resource "aws_iam_group_policy_attachment" "assessment_provisioners_no_backend_base" {
  provider = aws.users

  group      = aws_iam_group.assessment_provisioners_no_backend.name
  policy_arn = aws_iam_policy.provision_assessment_base.arn
}

# Attach the policy that allows assumption of all non-assessment roles
# needed in order to provision assessment environments, with the
# exception of Terraform backend access.
resource "aws_iam_group_policy_attachment" "assessment_provisioners_no_backend" {
  provider = aws.users

  group      = aws_iam_group.assessment_provisioners_no_backend.name
  policy_arn = aws_iam_policy.provision_assessment_no_backend.arn
}
