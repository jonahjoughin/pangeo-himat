resource "aws_vpc" "cluster" {
  cidr_block = "10.0.0.0/16"
  tags = "${
    map(
     "Name", "${var.cluster_name}_vpc",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_subnet" "cluster" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = "${aws_vpc.cluster.id}"
  tags = "${
    map(
     "Name", "${var.cluster_name}_subnet",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "cluster" {
  vpc_id = "${aws_vpc.cluster.id}"
  tags {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "cluster" {
  vpc_id = "${aws_vpc.cluster.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cluster.id}"
  }
}

resource "aws_route_table_association" "cluster" {
  count = 2
  subnet_id      = "${aws_subnet.cluster.*.id[count.index]}"
  route_table_id = "${aws_route_table.cluster.id}"
}

resource "aws_security_group" "cluster" {
  name = "${var.cluster_name}_cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.cluster.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.cluster_name}_cluster"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "cluster_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group" "workers" {
  name = "${var.cluster_name}_workers"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.cluster.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${
    map(
     "Name", "${var.cluster_name}_workers",
     "kubernetes.io/cluster/${var.cluster_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.workers.id}"
  source_security_group_id = "${aws_security_group.workers.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.workers.id}"
  source_security_group_id = "${aws_security_group.cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_workers" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.workers.id}"
  to_port                  = 443
  type                     = "ingress"
}
