resource "aws_ecr_repository" "backend" {
  name                 = "chatapp-backend"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "chatapp-frontend"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}
