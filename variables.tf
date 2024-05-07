# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "users" {
  description = "A list containing the usernames of users that exist in the Users account who are allowed to provision assessment environments.  Example: [ \"firstname1.lastname1\", \"firstname2.lastname2\" ]."
  type        = list(string)
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. us-east-1)."
  type        = string
}

variable "assessment_provisioners_group_name" {
  default     = "assessment_provisioners"
  description = "The name of the IAM group whose members are allowed to provision assessment environments."
  type        = string
}

variable "provision_assessment_policy_description" {
  default     = "Allows the assessment provisioner group to assume all roles needed in order to provision assessment environments."
  description = "The description to associate with the IAM policy in the Users account that allows the assessment provisioner group to assume all roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_policy_name" {
  default     = "AssumeProvisionAssessment"
  description = "The name of the IAM policy in the Users account that allows the assessment provisioner group to assume all roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_role_name" {
  default     = "ProvisionAccount"
  description = "The name of the IAM role in assessment accounts that includes all permissions necessary to provision the assessment environment in that account.  If this role does not exist in an account, an assessment environment cannot be provisioned in that account."
  type        = string
}

variable "startstopssmsession_role_name" {
  default     = "StartStopSSMSession"
  description = "The name of the IAM role in assessment accounts that includes all permissions necessary to start and stop an SSM session in that account."
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  type        = map(string)
}
