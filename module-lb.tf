module "lb" {
  source = "./modules/lb"

  vpc_id     = "${module.common.vpc_id}"
  install_id = "${module.common.install_id}"

  prefix = "${var.prefix}"
  domain = "${var.domain}"

  subnet_endpoints             = "${module.common.subnet_endpoints}"
  subnet_compute               = "${module.common.subnet_compute}"
  subnet_endpoints_cidr_blocks = "${module.common.subnet_endpoints_cidr_blocks}"
  subnet_compute_cidr_blocks   = "${module.common.subnet_compute_cidr_blocks}"
  internal_endpoint            = "${var.internal_endpoint}"

  hostname       = "${var.hostname}"
  update_route53 = "${var.update_route53}"

  cert_domain = "${var.cert_domain}"
  cert_arn    = "${var.cert_arn}"
}
