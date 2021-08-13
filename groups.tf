# An IAM group for assessment environment provisioners.
resource "aws_iam_group" "assessment_provisioners" {
  provider = aws.users

  name = var.assessment_provisioners_group_name
}

# Attach the policy that allows assumption of the provisioners role.
resource "aws_iam_group_policy_attachment" "assessment_provisioners" {
  provider = aws.users

  group      = aws_iam_group.assessment_provisioners.name
  policy_arn = aws_iam_policy.provision_assessment.arn
}
