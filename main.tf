provider "aws" { }

data "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket = "${var.bucket_remote_state}"
    key = "${var.bucket_remote_state}/env-${var.context_org}-global.tfstate"
  }
}

module "app" {
  source = "../module-aws-app"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"
}

module "default" {
  source = "../module-aws-service"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  cidr_blocks = "${var.cidr_blocks}"

  az_count = "${var.az_count}"
}

resource "aws_eip" "nat" {
  count = "${var.az_count}"

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.az_count}"

  subnet_id = "${element(split(" ", module.default.subnet_ids), count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
}
