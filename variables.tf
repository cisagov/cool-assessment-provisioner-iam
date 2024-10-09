# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "users" {
  description = "A map.  The keys are the names of users that exist in the Users account and are to be allowed to provision assessment environments.  The values are maps with a single key, \"backend_access\", which is a boolean value indicating whether or not the user should have general Terraform backend access.  Example: {\"firstname1.lastname1\" = {backend_access = true}}, {\"firstname2.lastname2\" = {backend_access = false}}."
  nullable    = false
  type        = map(object({ backend_access = bool }))
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

variable "assessment_provisioners_no_backend_group_name" {
  default     = "assessment_provisioners_no_backend"
  description = "The name of the IAM group whose members are allowed to provision assessment environments but do not have general access to the Terraform backend."
  type        = string
}

variable "provision_assessment_backend_policy_description" {
  default     = "Allows assumption of all non-assessment roles needed in order to provision assessment environments."
  description = "The description to associate with the IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_backend_policy_name" {
  default     = "AssumeProvisionAssessmentBackend"
  description = "The name of the IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_base_policy_description" {
  default     = "Allows assumption of all assessment roles needed in order to provision assessment environments."
  description = "The description to associate with the IAM policy in the Users account that allows assumption of all assessment roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_base_policy_name" {
  default     = "AssumeProvisionAssessment"
  description = "The name of the IAM policy in the Users account that allows the assessment provisioner group to assume all assessment roles needed in order to provision assessment environments."
  type        = string
}

variable "provision_assessment_no_backend_policy_description" {
  default     = "Allows assumption of all non-assessment roles needed in order to provision assessment environments, with the exception of backend access."
  description = "The description to associate with the IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments, with the exception of Terraform backend access."
  type        = string
}

variable "provision_assessment_no_backend_policy_name" {
  default     = "AssumeProvisionAssessmentNoBackend"
  description = "The name of the IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments, with the exception of Terraform backend access."
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
