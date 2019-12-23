module "common" {
  source           = "./modules/common-user-vpc"
  vpc_id           = "${var.vpc_id}"
  subnet_compute   = "${var.subnet_compute}"
  subnet_endpoints = "${var.subnet_endpoints}"
  allow_list       = "${var.allow_list}"
  prefix           = "${var.prefix}"
  tags             = "${var.tags}"
}
