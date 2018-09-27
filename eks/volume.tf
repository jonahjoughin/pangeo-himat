resource "aws_ebs_volume" "jupyter_volume" {
    availability_zone = "${var.cluster_region}a"
    size = "${var.jupyter_gb_storage}"
    tags {
        Name = "jupyter-volume"
    }
}
