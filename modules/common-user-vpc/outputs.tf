data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = "${slice(data.aws_availability_zones.available.names, 0, 2)}"
}

output "install_id" {
  value = "${random_string.install_id.result}"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}

output "availability_zones" {
  value = "${local.availability_zones}"
}

output "ssh_priv_key_file" {
  value = "${local.private_key_filename}"
}

output "ssh_key_name" {
  value = "${local.key_name}"
}

output "subnet_endpoints" {
  value = ["${data.aws_subnet.endpoints.*.id}"]
}

output "subnet_compute" {
  value = ["${data.aws_subnet.compute.*.id}"]
}

output "subnet_endpoints_cidr_blocks" {
  value = ["${data.aws_subnet.endpoints.*.cidr_block}"]
}

output "subnet_compute_cidr_blocks" {
  value = ["${data.aws_subnet.compute.*.cidr_block}"]
}

output "intra_vpc_and_egress_sg_id" {
  value = "${aws_security_group.intra_vpc_and_egress.id}"
}

output "allow_ptfe_sg_id" {
  value = "${aws_security_group.allow_ptfe.id}"
}

output "collect_diag_file" {
  value = "${path.module}/../common/files/collect-diag.sh" ## I am lazy
}
