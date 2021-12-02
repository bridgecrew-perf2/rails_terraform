provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {
  organization = "mountaincenter"
  token        = "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"
}