output "dask_url" {
  value = "${module.kubernetes.dask_url}"
}

output "jupyter_url" {
    value = "${module.kubernetes.jupyter_url}"
}
