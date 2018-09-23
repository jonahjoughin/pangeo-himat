output "token" {
  value = "${data.external.authenticator.result.token}"
}

output "dask_url" {
  value = "${data.kubernetes_service.dask-scheduler.load_balancer_ingress.0.hostname}:8786"
}

output "jupyter_url" {
    value = "${data.kubernetes_service.jupyter-server.load_balancer_ingress.0.hostname}:8888"
}
