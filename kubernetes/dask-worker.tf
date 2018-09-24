resource "kubernetes_replication_controller" "dask-worker" {
  metadata {
    name = "dask-worker"
    labels {
      app = "dask"
      role = "worker"
    }
  }
  spec {
    selector {
      app = "dask"
      role = "worker"
    }
    replicas = "${var.dask_worker_count}" # Arbitrarily large number of replicas. Need to figure out better way to do this
    template {
      container {
        image = "${var.worker_image}"
        name  = "dask-worker"
        command = ["dask-worker"]
        args =  ["dask-scheduler:8786", "--memory-limit", "1.6e9", "--nthreads", "1", "--nprocs", "1"]
        resources{
          requests{
            cpu    = "400m"
            memory = "1600Mi"
          }
        }
      }
      node_selector {
        kind = "spot"
      }
    }
  }
}
