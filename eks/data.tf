data "aws_availability_zones" "available" {}

# Save kubeconfig to file
resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${var.kubeconfig_output_path}"
  count    = "${var.apply_kubeconfig ? 1 : 0}"
}

# Save config_map to file
resource "local_file" "config_map" {
  content  = "${data.template_file.config_map.rendered}"
  filename = "${var.config_map_output_path}"
  count    = "${var.apply_config_map ? 1 : 0}"
}

# Apply config map automatically
resource "null_resource" "update_config_map" {
  provisioner "local-exec" {
    command = "[ -f ${var.config_map_output_path} ] && [ -f ${var.kubeconfig_output_path} ] && kubectl apply -f ${var.config_map_output_path} --kubeconfig ${var.kubeconfig_output_path}"
  }

  triggers {
    config_map_rendered = "${local_file.kubeconfig.content}"
    kubeconfig_rendered = "${local_file.config_map.content}"
  }

  depends_on = ["local_file.kubeconfig", "local_file.config_map"]

  count = "${var.apply_config_map ? 1 : 0}"
}

data "template_file" "config_map" {
  template = "${file("${path.module}/templates/config_map.yml.tpl")}"

  vars {
    worker_role_arn = "${aws_iam_role.workers.arn}"
  }
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/templates/kubeconfig.yml.tpl")}"

  vars {
    cluster_name                      = "${aws_eks_cluster.this.name}"
    endpoint                          = "${aws_eks_cluster.this.endpoint}"
    cluster_auth_base64               = "${aws_eks_cluster.this.certificate_authority.0.data}"
    aws_authenticator_command         = "aws-iam-authenticator"
  }
}

data "template_file" "stable_userdata" {
  template = "${file("${path.module}/templates/userdata.sh.tpl")}"

  vars {
    cluster_name        = "${aws_eks_cluster.this.name}"
    endpoint            = "${aws_eks_cluster.this.endpoint}"
    cluster_auth_base64 = "${aws_eks_cluster.this.certificate_authority.0.data}"
    kubelet_extra_args  = "--node-labels=kind=stable"
  }
}

data "template_file" "spot_userdata" {
  template = "${file("${path.module}/templates/userdata.sh.tpl")}"

  vars {
    cluster_name        = "${aws_eks_cluster.this.name}"
    endpoint            = "${aws_eks_cluster.this.endpoint}"
    cluster_auth_base64 = "${aws_eks_cluster.this.certificate_authority.0.data}"
    kubelet_extra_args  = "--node-labels=kind=spot"
  }
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}
