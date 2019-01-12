output "api-server.repository_url" {
  value = "${aws_ecr_repository.api-server.repository_url}"
}

output "graphql-server.repository_url" {
  value = "${aws_ecr_repository.graphql-server.repository_url}"
}
