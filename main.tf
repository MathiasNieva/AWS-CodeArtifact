resource "aws_kms_key" "codeartifact_key" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "codeartifact_domain" {
  domain         = "domain-upb"
  encryption_key = aws_kms_key.codeartifact_key.arn
}

resource "aws_codeartifact_repository" "codeartifact_upstream" {
  repository = "npm-store-upstream"
  description = "Provides npm artifacts from npm, Inc."
  domain     = aws_codeartifact_domain.codeartifact_domain.domain

  external_connections {
    external_connection_name = "public:npmjs"
  }
}

resource "aws_codeartifact_repository" "codeartifact_repository" {
  repository = "dev-team-1"
  domain     = aws_codeartifact_domain.codeartifact_domain.domain

  upstream {
    repository_name = aws_codeartifact_repository.codeartifact_upstream.repository
  }
}