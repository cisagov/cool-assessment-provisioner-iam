# Put assessment provisioner users in the appropriate group.
resource "aws_iam_user_group_membership" "assessment_provisioners" {
  provider = aws.users
  for_each = toset([for user in var.users : user.name])

  groups = [
    # This is yucky, but I don't know how else to deal with a list of
    # maps in Terraform.
    [for user in var.users : user.backend_access if user.name == each.value][0] ? aws_iam_group.assessment_provisioners.name : aws_iam_group.assessment_provisioners_no_backend.name
  ]
  user = each.value
}
