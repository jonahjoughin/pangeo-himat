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
      port = 80
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
            cpu = "${var.jupyter_milli_cpu}m"
            memory = "${var.jupyter_mb_ram}Mi"
          }
        }
        volume_mount {
          mount_path = "/home/jupyter/persistent"
          name = "jupyter-volume"
        }
      }
      volume {
        name = "jupyter-volume"
        persistent_volume_claim {
          claim_name = "jupyter-volume"
        }
      }
      node_selector {
        kind = "stable"
      }
    }
  }
}

resource "kubernetes_persistent_volume" "jupyter-volume" {
  metadata {
    name            = "jupyter-volume"
  }
  spec {
    capacity {
      storage       = "${var.jupyter_gb_storage}Gi"
    }

    access_modes    = ["ReadWriteOnce"]

    persistent_volume_source {
      aws_elastic_block_store {
        volume_id   = "${var.jupyter_volume_id}"
        fs_type     = "ext4"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "jupyter-volume" {
  metadata {
    name            = "jupyter-volume"
  }
  spec {
    resources {
      requests {
        storage     = "${var.jupyter_gb_storage}Gi"
      }
    }
    access_modes    = ["ReadWriteOnce"]
    volume_name     = "jupyter-volume"
  }
  depends_on = ["kubernetes_persistent_volume.jupyter-volume"]
}
