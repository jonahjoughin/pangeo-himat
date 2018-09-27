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
        args =  ["dask-scheduler:8786", "--memory-limit", "${var.dask_worker_mb_ram}000000", "--nthreads", "${var.dask_worker_threads}", "--nprocs", "${var.dask_worker_procs}"]
        resources{
          requests{
            cpu    = "${var.dask_worker_milli_cpu}m"
            memory = "${var.dask_worker_mb_ram}Mi"
          }
        }
      }
      node_selector {
        kind = "spot"
      }
    }
  }
}
