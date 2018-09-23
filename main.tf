# Workaround for strange terraform bug
provider "aws" {
  region= "us-west-2"
}

provider "aws" {
  region = "${var.cluster_region}"
  alias = "use1"
}

module "eks" {
  source = "./eks"

  cluster_name = "${var.cluster_name}"
  cluster_region = "${var.cluster_region}"
  cluster_version = "${var.cluster_version}"
  stable_instance_type = "${var.stable_instance_type}"
  spot_instance_type = "${var.spot_instance_type}"
  spot_pool_size = "${var.spot_pool_size}"
  config_map_output_path = "${var.config_map_output_path}"
  kubeconfig_output_path = "${var.kubeconfig_output_path}"
  apply_config_map = "${var.apply_config_map}"
  apply_kubeconfig = "${var.apply_kubeconfig}"

  providers = {
    aws = "aws.use1"
  }
}

module "kubernetes" {
  source = "./kubernetes"

  cluster_name = "${var.cluster_name}"
  cluster_endpoint = "${module.eks.cluster_endpoint}"
  cluster_certificate_authority_data = "${module.eks.cluster_certificate_authority_data}"
}
