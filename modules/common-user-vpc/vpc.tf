data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "compute" {
  count = "${length(var.subnet_compute)}"
  id    = "${var.subnet_compute[count.index]}"
}

data "aws_subnet" "endpoints" {
  count = "${length(var.subnet_endpoints)}"
  id    = "${var.subnet_endpoints[count.index]}"
}
