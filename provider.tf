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
    secret       = "VeryRandomStringMoreThan20Byte!"
    content_type = "json"
    insecure_ssl = true
  }
  events = ["push"]
}
