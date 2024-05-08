output "assessment_provisioners_group" {
  description = "The IAM group whose members are allowed to provision assessment environments."
  value       = aws_iam_group.assessment_provisioners
}

output "assessment_provisioners_policy" {
  description = "The IAM policy in the Users account that allows the assessment provisioners group to assume the provisioning role in assessment accounts."
  value       = aws_iam_policy.provision_assessment
}
