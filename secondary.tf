resource "aws_launch_configuration" "secondary" {
  image_id      = "${var.ami != "" ? var.ami : local.distro_ami}"
  instance_type = "${local.rendered_secondary_instance_type}"

  key_name = "${module.common.ssh_key_name}"

  user_data = "${data.template_cloudinit_config.config_secondary.rendered}"

  security_groups = [
    ## ingress from lb
    "${module.lb.sg_lb_to_instance}",

    ## unrestricted egress
    "${module.common.intra_vpc_and_egress_sg_id}",

    "${module.common.allow_ptfe_sg_id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.ptfe.name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
  }
}

resource "aws_autoscaling_group" "secondary" {
  # Interpolating the LC name into the ASG name here causes any changes that
  # would replace the LC (like, most commonly, an AMI ID update) to _also_
  # replace the ASG.
  name = "${var.prefix}-lc-${aws_launch_configuration.secondary.name}"

  launch_configuration = "${aws_launch_configuration.secondary.name}"
  desired_capacity     = "${var.secondary_count}"
  min_size             = "${var.secondary_count}"
  max_size             = "${var.secondary_count}"
  vpc_zone_identifier  = ["${module.common.subnet_compute}"]
  target_group_arns    = ["${module.lb.https_group}"]

  #   This tag is a list of maps. autoscaling resource behaves different
  # than other resources.
  tags = [
    "${list(
      var.tags,
      map(
        "Name", "${var.prefix}-lc-${aws_launch_configuration.secondary.name}",
        "InstallationId", "${module.common.install_id}",
        "Hostname", "${module.lb.endpoint}"
      )
    )}"
  ]
}
