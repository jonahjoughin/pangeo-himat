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
  # Cluster info
  cluster_name = "${var.cluster_name}"
  cluster_region = "${var.cluster_region}"
  cluster_version = "${var.cluster_version}"
  # Node types
  stable_instance_type = "${var.stable_instance_type}"
  spot_instance_type = "${var.spot_instance_type}"
  # Dask worker pool size
  spot_node_count = "${var.spot_node_count}"
  # Jupyter notebook resources
  jupyter_gb_storage = "${var.jupyter_gb_storage}"
  # File output paths
  config_map_output_path = "${var.config_map_output_path}"
  kubeconfig_output_path = "${var.kubeconfig_output_path}"

  providers = {
    aws = "aws.use1"
  }
}

module "kubernetes" {
  source = "./k8s"
  # Cluster info
  cluster_name = "${var.cluster_name}"
  cluster_endpoint = "${module.eks.cluster_endpoint}"
  cluster_certificate_authority_data = "${module.eks.cluster_certificate_authority_data}"
  # Docker image
  worker_image = "${var.worker_image}"
  # Dask worker pool size
  dask_worker_count = "${var.dask_worker_count}"
  # Dask worker resources
  dask_worker_mb_ram = "${var.dask_worker_mb_ram}"
  dask_worker_milli_cpu = "${var.dask_worker_milli_cpu}"
  dask_worker_threads = "${var.dask_worker_threads}"
  dask_worker_procs = "${var.dask_worker_procs}"
  # Dask scheduler resources
  dask_scheduler_mb_ram = "${var.dask_scheduler_mb_ram}"
  dask_scheduler_milli_cpu = "${var.dask_scheduler_milli_cpu}"
  # Jupyter notebook resources
  jupyter_mb_ram = "${var.jupyter_mb_ram}"
  jupyter_milli_cpu = "${var.jupyter_milli_cpu}"
  jupyter_gb_storage = "${var.jupyter_gb_storage}"
  jupyter_volume_id = "${module.eks.jupyter_volume_id}"
}
