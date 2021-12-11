resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "データベースのユーザー名"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  value       = "uninitialized"
  type        = "SecureString"
  description = "データベースのパスワード"

  lifecycle {
    ignore_changes = [value]
  }
}

# resource "aws_ssm_parameter" "github_personal_access_token" {
#   name        = "github-personal-access-token"
#   description = "github-personal-access-token"
#   type        = "String"
#   value       = file("./secrets/github_personal_access_token")
# }