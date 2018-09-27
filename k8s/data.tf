data "external" "authenticator" {
  program = ["bash", "${path.module}/authenticate.sh"]

  query {
    cluster_name = "${var.cluster_name}"
  }
}
