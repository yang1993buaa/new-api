provider "tencentcloud" {
  region     = var.region
  secret_id  = var.secret_id
  secret_key = var.secret_key
}

# Kubernetes Provider — 通过独立的 cluster_endpoint 资源连接
# 该资源在集群和节点池创建完成后才会开启公网访问
provider "kubernetes" {
  host = try(
    tencentcloud_kubernetes_cluster_endpoint.main.cluster_external_endpoint,
    "https://placeholder.invalid"
  )
  cluster_ca_certificate = try(
    base64decode(tencentcloud_kubernetes_cluster_endpoint.main.certification_authority),
    ""
  )
  username = try(
    tencentcloud_kubernetes_cluster_endpoint.main.user_name,
    ""
  )
  password = try(
    tencentcloud_kubernetes_cluster_endpoint.main.password,
    ""
  )
}
