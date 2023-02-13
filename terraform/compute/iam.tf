resource "aws_iam_role" "deploy_role" {
  name               = "${var.UNIQUE_IDENTIFIER}-deploy-role"
  assume_role_policy = file("compute/policies/assume_role_policy.json")
}

resource "aws_iam_instance_profile" "deploy_profile" {
  name = "${var.UNIQUE_IDENTIFIER}-deploy-profile"
  role = aws_iam_role.deploy_role.name
}

resource "aws_iam_policy" "deploy_policy" {
  name        = "${var.UNIQUE_IDENTIFIER}-deploy-policy"
  description = "Permissions to deploy application"
  policy      = file("compute/policies/deploy_policy.json")
}

resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}