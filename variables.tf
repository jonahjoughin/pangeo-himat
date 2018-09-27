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

variable "worker_image" {
  description = "Docker image to pull for worker nodes"
}

variable "spot_node_count" {
  description = "EC2 instance type for spot nodes"
}

variable "dask_worker_count" {
  description = "Number of dask workers to schedule"
}

variable "dask_worker_mb_ram" {
  description = "Dask worker RAM in Mb"
}

variable "dask_worker_milli_cpu" {
  description = "Dask worker CPU in millicores"
}

variable "dask_worker_threads" {
  description = "Number of threads spawned by dask worker"
}

variable "dask_worker_procs" {
  description = "Number of processes spawned by dask worker"
}

variable "dask_scheduler_mb_ram" {
  description = "Dask scheduler RAM in Mb"
}

variable "dask_scheduler_milli_cpu" {
  description = "Dask scheduler CPU in millicores"
}

variable "jupyter_mb_ram" {
  description = "Jupyter notebook RAM in Mb"
}

variable "jupyter_milli_cpu" {
  description = "Jupyter notebook CPU in millicores"
}

variable "jupyter_gb_storage" {
  description = "Jupyter volume size in gigabytes"
}

variable "config_map_output_path" {
  description = "Determines where config_map files are placed"
}

variable "kubeconfig_output_path" {
  description = "Determines where config_map files are placed"
}
