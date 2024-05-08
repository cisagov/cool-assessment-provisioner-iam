# Put assessment provisioner users in the appropriate group.
resource "aws_iam_user_group_membership" "assessment_provisioners" {
  provider = aws.users
  for_each = toset(var.users)

  groups = [
    aws_iam_group.assessment_provisioners.name
  ]
  user = each.key
}
