output "assessment_provisioners_group" {
  value       = aws_iam_group.assessment_provisioners
  description = "The IAM group whose members are allowed to provision assessment environments."
}

output "assessment_provisioners_policy" {
  value       = aws_iam_policy.provision_assessment
  description = "The IAM policy in the Users account that allows the assessment provisioners group to assume the provisioning role in assessment accounts."
}
