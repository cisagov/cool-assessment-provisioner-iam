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
  all_non_assessment_account_ids = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.id
    if length(regexall("^env[[:digit:]]+ \\(.*\\)$", account.name)) == 0
  ]

  # Create a list of all provision roles in non-assessment accounts.
  all_non_assessment_provision_roles = formatlist("arn:aws:iam::%s:role/%s", local.all_non_assessment_account_ids, var.provision_assessment_role_name)

  # Create a list of all startstopssmsession roles in non-assessment accounts.
  all_non_assessment_startstopssmsession_roles = formatlist("arn:aws:iam::%s:role/%s", local.all_non_assessment_account_ids, var.startstopssmsession_role_name)

  # Assumption of the following non-assessment account roles is required
  # to successfully provision assessment environments.
  # TODO: Determine if it is possible/worthwhile to replace any
  # "provision account" roles below with something less powerful.  New roles
  # would need to be created in appropriate repositories, then used in
  # cisagov/cool-assessment-terraform and also included below.
  # See https://github.com/cisagov/cool-assessment-terraform/issues/133.
  required_non_assessment_roles_no_backend = [
    data.terraform_remote_state.dns_certboto.outputs.provisioncertificatereadroles_role.arn,
    data.terraform_remote_state.images_parameterstore-production.outputs.parameterstorereadonly_role.arn,
    data.terraform_remote_state.images_parameterstore-production.outputs.provisionparameterstorereadroles_role.arn,
    data.terraform_remote_state.images_parameterstore-staging.outputs.parameterstorereadonly_role.arn,
    data.terraform_remote_state.images_parameterstore-staging.outputs.provisionparameterstorereadroles_role.arn,
    data.terraform_remote_state.master.outputs.organizationsreadonly_role.arn,
    data.terraform_remote_state.sharedservices-production.outputs.provisionaccount_role.arn,
    data.terraform_remote_state.sharedservices-staging.outputs.provisionaccount_role.arn,
    data.terraform_remote_state.terraform.outputs.provisionaccount_role.arn,
    data.terraform_remote_state.users.outputs.provisionaccount_role.arn,
  ]
  required_non_assessment_roles_backend = concat(local.required_non_assessment_roles_no_backend, [
    data.terraform_remote_state.terraform.outputs.access_terraform_backend_role.arn,
  ])

  # Create set of prohibited non-assessment account provision roles.
  prohibited_non_assessment_provision_roles_no_backend = setsubtract(local.all_non_assessment_provision_roles, local.required_non_assessment_roles_no_backend)
  prohibited_non_assessment_provision_roles_backend    = setsubtract(local.all_non_assessment_provision_roles, local.required_non_assessment_roles_backend)

  # Create comprehensive set of prohibited non-assessment account roles.
  prohibited_non_assessment_roles_no_backend = setunion(local.prohibited_non_assessment_provision_roles_no_backend, local.all_non_assessment_startstopssmsession_roles)
  prohibited_non_assessment_roles_backend    = setunion(local.prohibited_non_assessment_provision_roles_backend, local.all_non_assessment_startstopssmsession_roles)
}
