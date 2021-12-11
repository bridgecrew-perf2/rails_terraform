resource "aws_codestarconnections_connection" "github" {
  name          = "${var.r_prefix}-github"
  provider_type = "GitHub"
}
resource "aws_codepipeline" "example" {
  name     = var.r_prefix
  role_arn = module.codepipeline_role.iam_role_arn
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      output_artifacts = ["Source"]
      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = data.github_repository.example.full_name
        BranchName           = data.github_repository.example.branches[0]["name"]
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]
      configuration = {
        ProjectName = aws_codebuild_project.example.id
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["Build"]
      configuration = {
        ClusterName = aws_ecs_cluster.example.name
        ServiceName = aws_ecs_service.example.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }
}

resource "aws_codepipeline_webhook" "example" {
  name            = var.r_prefix
  target_pipeline = aws_codepipeline.example.name
  target_action   = "Source"
  authentication  = "GITHUB_HMAC"
  authentication_configuration {
    secret_token = "VeryRandomStringMoreThan20Byte!"
  }
  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
