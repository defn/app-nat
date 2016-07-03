resource "aws_eip" "nat" {
  count = "${var.az_count}"

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.az_count}"

  subnet_id = "${element(module.default.subnet_ids,count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id,count.index)}"
}

output "nat_ids" {
  value = [ "${aws_nat_gateway.nat.*.id}" ]
}

output "nat_eips" {
  value = [ "${aws_eip.nat.*.public_ip}" ]
}
