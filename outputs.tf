output "assessment_provisioners_group" {
  description = "The IAM group whose members are allowed to provision assessment environments."
  value       = aws_iam_group.assessment_provisioners
}

output "assessment_provisioners_no_backend_group" {
  description = "The IAM group whose members are allowed to provision assessment environments but do not have general access to the Terraform backend."
  value       = aws_iam_group.assessment_provisioners_no_backend
}

output "assessment_provisioners_backend_policy" {
  description = "The IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments."
  value       = aws_iam_policy.provision_assessment_backend
}

output "assessment_provisioners_base_policy" {
  description = "The IAM policy in the Users account that allows assumption of all assessment roles needed in order to provision assessment environments."
  value       = aws_iam_policy.provision_assessment_base
}

output "assessment_provisioners_no_backend_policy" {
  description = "The IAM policy in the Users account that allows assumption of all non-assessment roles needed in order to provision assessment environments, with the exception of Terraform backend access."
  value       = aws_iam_policy.provision_assessment_no_backend
}
