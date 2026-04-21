provider "tencentcloud" {
  region     = var.region
  secret_id  = var.secret_id
  secret_key = var.secret_key
}

# Kubernetes Provider — 通过独立的 cluster_endpoint 资源连接
# 使用 locals + try 保证 provider 配置在集群未创建时也能工作
locals {
  k8s_endpoint = try(
    tencentcloud_kubernetes_cluster_endpoint.main.cluster_external_endpoint,
    ""
  )
  k8s_username = try(
    tencentcloud_kubernetes_cluster_endpoint.main.user_name,
    ""
  )
  k8s_password = try(
    tencentcloud_kubernetes_cluster_endpoint.main.password,
    ""
  )
}

provider "kubernetes" {
  host     = local.k8s_endpoint != "" ? local.k8s_endpoint : "https://127.0.0.1"
  username = local.k8s_username
  password = local.k8s_password
  insecure = true
}
