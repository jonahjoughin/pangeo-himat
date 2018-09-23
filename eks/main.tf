resource "aws_eks_cluster" "this" {
  name = "${var.cluster_name}"
  role_arn = "${aws_iam_role.cluster.arn}"
  version  = "${var.cluster_version}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster.id}"]
    subnet_ids         = ["${aws_subnet.cluster.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy",
  ]
}

resource "aws_launch_configuration" "stable_pool" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.workers.name}"
  image_id                    = "${data.aws_ami.eks_worker.id}"
  instance_type               = "${var.stable_instance_type}"
  name_prefix                 = "stable"
  security_groups             = ["${aws_security_group.workers.id}"]
  user_data                   = "${base64encode(data.template_file.stable_userdata.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "spot_pool" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.workers.name}"
  image_id                    = "${data.aws_ami.eks_worker.id}"
  instance_type               = "${var.spot_instance_type}"
  name_prefix                 = "spot"
  security_groups             = ["${aws_security_group.workers.id}"]
  user_data                   = "${base64encode(data.template_file.spot_userdata.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "stable_pool" {
  launch_configuration = "${aws_launch_configuration.stable_pool.id}"
  desired_capacity     = 1
  max_size             = 1
  min_size             = 0
  name                 = "${var.cluster_name}_stable"
  vpc_zone_identifier  = ["${aws_subnet.cluster.*.id}"]
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}_stable"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

# Create worker scaling group
resource "aws_autoscaling_group" "spot_pool" {
  launch_configuration = "${aws_launch_configuration.spot_pool.id}"
  desired_capacity     = "${var.spot_pool_size}"
  max_size             = 10
  min_size             = 0
  name                 = "${var.cluster_name}_spot"
  vpc_zone_identifier  = ["${aws_subnet.cluster.*.id}"]
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}_spot"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
