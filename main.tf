provider "aws" {
  region = "${var.provider_region}"
}

module "app" {
  source = "../module-aws-app"

  provider_region = "${var.provider_region}"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  az_count = "${var.az_count}"
}

module "service" {
  source = "../module-aws-service"

  provider_region = "${var.provider_region}"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  az_count = "${var.az_count}"

  cidr_blocks = "${var.cidr_blocks}"
}
