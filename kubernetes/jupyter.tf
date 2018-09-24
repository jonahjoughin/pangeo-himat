resource "kubernetes_service" "jupyter-server" {
  metadata {
    name = "jupyter-server"
  }
  spec {
    selector {
      app = "jupyter"
      role = "server"
    }
    port {
      port = 8888
      target_port = 8888
      name = "http"
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "jupyter-server" {
  metadata {
    name = "jupyter-server"
  }
  depends_on = ["kubernetes_service.jupyter-server"]
}

resource "kubernetes_replication_controller" "jupyter-server" {
  metadata {
    name = "jupyter-server"
    labels {
      app = "jupyter"
      role = "server"
    }
  }
  spec {
    selector {
      app = "jupyter"
      role = "server"
    }
    template {
      container {
        image = "${var.worker_image}"
        name  = "jupyter-server"
        command = ["jupyter"]
        args = ["notebook", "--allow-root", "--config", "notebook_config.py"]
        port {
          container_port = 8888
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
