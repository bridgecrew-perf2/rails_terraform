provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.18.2"
    }
  }
}

provider "github" {
  owner = "mountaincenter"
  token = "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"
}

data "github_user" "current" {
  username = ""
}
data "github_repository" "example" {
  full_name = "mountaincenter/rails_terraform"
}

resource "github_repository_webhook" "example" {
  repository = data.github_repository.example.name
  configuration {
    url          = aws_codepipeline_webhook.example.url
    secret       = aws_ssm_parameter.github_personal_access_token.value
    content_type = "json"
    insecure_ssl = true
  }
  events = ["push"]
}