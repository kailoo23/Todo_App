# Configure the Kubernetes provider
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"  # Use a recent version
    }
  }
}

provider "kubernetes" {
  # This configures kubectl to use your current context (Minikube)
  config_path = "~/.kube/config"
}

# Create a Kubernetes namespace
resource "kubernetes_namespace" "todo_app" {
  metadata {
    name = "todo-app"
  }
}

# Create a Kubernetes Deployment
resource "kubernetes_deployment" "todo_app" {
  metadata {
    name      = "todo-app-deployment"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
    labels = {
      app = "todo-app"
    }
  }

  spec {
    replicas = 3  # High availability: Run 3 instances

    selector {
      match_labels = {
        app = "todo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "todo-app"
        }
      }

      spec {
        container {
          image = "todo-list-app:latest"  # Use the image built by Docker
          name  = "todo-app-container"
          ports {
            container_port = 5000
          }
          # Add readiness and liveness probes (recommended)
          readiness_probe {
            http_get {
              path = "/"
              port = 5000
            }
            initial_delay_seconds = 5
            period_seconds = 10
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 5000
            }
            initial_delay_seconds = 15
            period_seconds = 20
          }
        }
      }
    }
  }
}

# Create a Kubernetes Service (LoadBalancer)
resource "kubernetes_service" "todo_app" {
  metadata {
    name      = "todo-app-service"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
  }
  spec {
    selector = {
      app = "todo-app"
    }
    port {
      port        = 80
      target_port = 5000
    }
    type = "LoadBalancer"  # Expose the service externally
  }
}
