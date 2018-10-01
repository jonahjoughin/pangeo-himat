# Cluster info
cluster_name = "pangeo-himat"
cluster_region = "us-west-2"
cluster_version = "1.10"
# Node types (changes will affect cost)
stable_instance_type = "m5.xlarge"
spot_instance_type = "m5.xlarge"
# Docker image
worker_image = "jonahjoughin/pangeo-himat:latest"
# Dask worker pool size (changes will affect cost)
spot_node_count = 3
# Make sure this value is sufficiently large that all workers are scheduled
dask_worker_count = 100

# TODO: hibernate = false

# ------------------------------------------------------------------------------------------------------- #
# Note: Make sure that scheduler and notebook resources can be scheduled on stable instance simutaneously #
# ------------------------------------------------------------------------------------------------------- #

# Dask worker resources
dask_worker_mb_ram = 1600 # 1.6Gb
dask_worker_milli_cpu = 400 # 0.4 cores
dask_worker_threads = 1
dask_worker_procs = 1
# Dask scheduler resources
dask_scheduler_mb_ram = 6000 # 6Gb
dask_scheduler_milli_cpu = 1500 # 1.5 cores
# Jupyter notebook resources
jupyter_mb_ram = 6000 # 6Gb
jupyter_milli_cpu = 1500 # 1.5 cores
jupyter_gb_storage = 16 # 16Gb
# File output paths
config_map_output_path = "./config_map.yml"
kubeconfig_output_path = "./kubeconfig.yml"
