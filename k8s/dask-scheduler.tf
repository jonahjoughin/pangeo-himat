resource "kubernetes_service" "dask-scheduler" {
  metadata {
    name = "dask-scheduler"
  }
  spec {
    selector {
      app = "dask"
      role = "scheduler"
    }
    port {
      port = 8786
      target_port = 8786
      name = "scheduler"
    }
    port {
      port = 80
      target_port = 8787
      name = "bokeh"
    }
    port {
      port = 9786
      target_port = 9786
      name = "http"
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "dask-scheduler" {
  metadata {
    name = "dask-scheduler"
  }
  depends_on = ["kubernetes_service.dask-scheduler"]
}

resource "kubernetes_replication_controller" "dask-scheduler" {
  metadata {
    name = "dask-scheduler"
    labels {
      app = "dask"
      role = "scheduler"
    }
  }
  spec {
    selector {
      app = "dask"
      role = "scheduler"
    }
    template {
      container {
        image = "${var.worker_image}"
        name  = "jupyter-server"
        command = ["dask-scheduler"]
        port {
          container_port = 8786
        }
        resources {
          requests {
            memory = "6000Mi"
            cpu = "1500m"
          }
        }
      }
      node_selector {
        kind = "stable"
      }
    }
  }
}
