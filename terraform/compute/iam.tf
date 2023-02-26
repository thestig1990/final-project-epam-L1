# Creating an IAM role
resource "aws_iam_role" "deploy_role" {
  name               = "${var.UNIQUE_IDENTIFIER}-deploy-role"
  assume_role_policy = file("compute/policies/assume_role_policy.json") # The policy that grants an entity permission to assume the role.
}

# Creating an IAM instance profile
resource "aws_iam_instance_profile" "deploy_profile" {
  name = "${var.UNIQUE_IDENTIFIER}-deploy-profile"
  role = aws_iam_role.deploy_role.name
}

# Creating an IAM policy
resource "aws_iam_policy" "deploy_policy" {
  name        = "${var.UNIQUE_IDENTIFIER}-deploy-policy"
  description = "Permissions to deploy application"
  policy      = file("compute/policies/deploy_policy.json")
}

# Attaching an IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}