resource "aws_eip" "nat" {
  count = "${var.az_count}"

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.az_count}"

  subnet_id = "${element(module.default.subnet_ids,count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id,count.index)}"
}
