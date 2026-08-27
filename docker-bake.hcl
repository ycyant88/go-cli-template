variable "CLI_NAME" {
  default = "go-cli"
}

variable "CI_COMMIT_SHA" {
  default = ""
}

variable "CI_PROJECT_URL" {
  default = ""
}

variable "CI_COMMIT_TAG" {
  default = "dev"
}

variable "AWS_ECR_PRIVATE_URI" {
  default = "439152312044.dkr.ecr.ap-southeast-1.amazonaws.com/${CLI_NAME}"
}

target "metadata" {
  labels = {
    "org.opencontainers.image.description" = "${CLI_NAME} written in go."
    "org.opencontainers.image.revision"    = "${CI_COMMIT_SHA}"
    "org.opencontainers.image.source"      = "${CI_PROJECT_URL}"
    "org.opencontainers.image.title"       = "${CLI_NAME}"
    "org.opencontainers.image.url"         = "${CI_PROJECT_URL}"
    "org.opencontainers.image.version"     = "${CI_COMMIT_TAG}"
  }
}

target "settings" {
  context    = "."
  dockerfile = "Dockerfile"
}

target "build-amd64" {
  inherits  = ["settings", "metadata"]
  target    = "dist"
  platforms = ["linux/amd64"]
  output    = ["type=tar,dest=./dist/${CLI_NAME}_${CI_COMMIT_TAG}_linux_amd64.tar"]
}

target "build-arm64" {
  inherits  = ["settings", "metadata"]
  target    = "dist"
  platforms = ["linux/arm64"]
  output    = ["type=tar,dest=./dist/${CLI_NAME}_${CI_COMMIT_TAG}_linux_arm64.tar"]
}

target "push" {
  inherits  = ["settings", "metadata"]
  target    = "push"
  platforms = ["linux/amd64", "linux/arm64"]
  output    = ["type=registry"]
  tags = [
    "${AWS_ECR_PRIVATE_URI}:latest",
    "${AWS_ECR_PRIVATE_URI}:${CI_COMMIT_SHA}",
    "${AWS_ECR_PRIVATE_URI}:${CI_COMMIT_TAG}",
  ]
}

group "default" {
  targets = ["build"]
}

group "build" {
  targets = ["build-amd64", "build-arm64"]
}
