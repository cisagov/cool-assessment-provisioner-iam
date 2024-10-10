# Put assessment provisioner users in the appropriate group.
resource "aws_iam_user_group_membership" "assessment_provisioners" {
  provider = aws.users
  for_each = var.users

  groups = [
    each.value.backend_access ? aws_iam_group.assessment_provisioners.name : aws_iam_group.assessment_provisioners_no_backend.name
  ]
  user = each.key
}
