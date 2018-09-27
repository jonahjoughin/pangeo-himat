# Cluster info
cluster_name = "beta"
cluster_region = "us-west-2"
cluster_version = "1.10"
# Node types
stable_instance_type = "m5.xlarge"
spot_instance_type = "m5.xlarge"
# Docker image
worker_image = "jonahjoughin/pangeo-cluster:latest"
# Dask worker pool size
spot_node_count = 3
dask_worker_count = 250
# Dask worker resources
dask_worker_mb_ram = 1600
dask_worker_milli_cpu = 400
# Dask scheduler resources
dask_scheduler_mb_ram = 6000
dask_scheduler_milli_cpu = 1500
# Jupyter notebook resources
jupyter_mb_ram = 6000
jupyter_milli_cpu = 1500
jupyter_gb_storage = 16
# File output paths
config_map_output_path = "./config_map.yml"
kubeconfig_output_path = "./kubeconfig.yml"
