# ------------------------------------------------------------------------------
# Retrieve the effective Account ID, User ID, and ARN in which Terraform is
# authorized.  This is used to calculate the session names for assumed roles.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "default" {}

# ------------------------------------------------------------------------------
# Retrieve the information for all accounts in the organization.
# ------------------------------------------------------------------------------
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
}

# ------------------------------------------------------------------------------
# Retrieve the caller identity for the Users provider in order to get
# the associated Account ID.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "users" {
  provider = aws.users
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.default.arn)[1]

  # Get IDs of all non-assessment accounts in the organization, i.e. those
  # that don't have account names like: "env[:digit:] (.*)"
  # These non-assessment accounts will NOT be allowed to be provisioned by
  # the users in this project.
  non_assessment_account_ids = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.id
    if length(regexall("^env[[:digit:]]+ \\(.*\\)$", account.name)) == 0
  ]
}
