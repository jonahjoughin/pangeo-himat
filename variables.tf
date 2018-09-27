variable "cluster_name" {}

variable "cluster_region" {
  description = "Region to locate EKS cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
}

variable "stable_instance_type" {
  description = "EC2 instance type for stable nodes"
}

variable "spot_instance_type" {
  description = "EC2 instance type for spot nodes"
}

variable "spot_node_count" {
  description = "EC2 instance type for spot nodes"
}

variable "dask_worker_count" {
  description = "Number of dask workers to schedule"
}

variable "config_map_output_path" {
  description = "Determines where config_map files are placed"
}

variable "kubeconfig_output_path" {
  description = "Determines where config_map files are placed"
}

variable "apply_kubeconfig" {
  description = "Whether to write the kubeconfig file"
}

variable "apply_config_map" {
  description = "Whether to write and apply the config_map file."
}

variable "worker_image" {
  description = "Docker image to pull for worker nodes"
}

variable "jupyter_volume_gb" {
  description = "Jupyter volume size in gigabytes"
}
