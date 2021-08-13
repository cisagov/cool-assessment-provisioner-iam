# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "users" {
  type        = list(string)
  description = "A list containing the usernames of users that exist in the Users account who are allowed to provision assessment environments.  Example: [ \"firstname1.lastname1\", \"firstname2.lastname2\" ]."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "assessment_provisioners_group_name" {
  type        = string
  description = "The name of the IAM group whose members are allowed to provision assessment environments."
  default     = "assessment_provisioners"
}

variable "provision_assessment_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy in the Users account that allows the assessment provisioner group to assume the provisioner role in assessment accounts."
  default     = "Allows the assessment provisioner group to assume the provisioner role in assessment accounts."
}

variable "provision_assessment_policy_name" {
  type        = string
  description = "The name of the IAM policy in the Users account that allows the assessment provisioner group to assume the provisioner role in assessment accounts."
  default     = "AssumeProvisionAssessment"
}

variable "provision_assessment_role_name" {
  type        = string
  description = "The name of the IAM role in assessment accounts that includes all permissions necessary to provision the assessment environment in that account.  If this role does not exist in an account, an assessment environment cannot be provisioned in that account."
  default     = "ProvisionAccount"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
