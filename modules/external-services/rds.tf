locals {
  postgres_port = "5432"
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "rds" {
  vpc_id = "${var.vpc_id}"
  ids    = "${var.rds_subnet_ids}"
}

data "aws_subnet" "access" {
  vpc_id = "${var.vpc_id}"
  ids   = "${var.access_subnet_ids}"
}

resource "aws_security_group" "db_access" {
  description = "allow instances to talk to each other, and have unfettered egress"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = "${local.postgres_port}"
    to_port   = "${local.postgres_port}"

    cidr_blocks = [
      "${data.aws_subnet.rds.*.cidr_block}",
      "${data.aws_subnet_.access.*.cidr_block}"
    ]
  }

  tags = "${merge(
    var.tags,
    map("Name", "DB Access for ${local.namespace}")
  )}"
}

resource "random_string" "database_password" {
  length  = 40
  special = false
}

resource "aws_db_subnet_group" "tfe" {
  name_prefix = "${local.namespace}"
  subnet_ids  = ["${data.aws_subnet.rds.*.id}"]

  tags = "${merge(
    var.tags,
    map("Name", "${local.namespace} subnet group")
  )}"
}

resource "aws_rds_cluster" "tfe" {
  cluster_identifier_prefix = "${var.prefix}tfe-${var.install_id}"
  engine                    = "aurora-postgresql"
  database_name             = "${var.database_name}"
  master_username           = "${var.database_username}"
  master_password           = "${random_string.database_password.result}"
  db_subnet_group_name      = "${aws_db_subnet_group.tfe.name}"
  backup_retention_period   = 5
  preferred_backup_window   = "07:00-09:00"
  vpc_security_group_ids    = ["${aws_security_group.db_access.id}"]
  final_snapshot_identifier = "${local.namespace}-final"

  tags = "${merge(
    var.tags,
    map("Name", "${local.namespace} RDS Cluster Group"
  )}"
}

resource "aws_rds_cluster_instance" "tfe1" {
  apply_immediately    = true
  cluster_identifier   = "${aws_rds_cluster.tfe.id}"
  identifier_prefix    = "${var.prefix}tfe1"
  engine               = "aurora-postgresql"
  instance_class       = "db.r5.large"
  db_subnet_group_name = "${aws_db_subnet_group.tfe.name}"

  tags = "${merge(
    var.tags,
    map("Name", "${local.namespace} Cluster Instance")
  )}"
}
