output "dask_url" {
  value = "${data.kubernetes_service.dask-scheduler.load_balancer_ingress.0.hostname}/status"
}

output "jupyter_url" {
    value = "${data.kubernetes_service.jupyter-server.load_balancer_ingress.0.hostname}"
}
