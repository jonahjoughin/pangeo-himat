provider "kubernetes" {
  load_config_file = false
  host = "${var.cluster_endpoint}"
  cluster_ca_certificate = "${base64decode(var.cluster_certificate_authority_data)}"
  token                  = "${data.external.authenticator.result.token}"
  load_config_file       = false
}
