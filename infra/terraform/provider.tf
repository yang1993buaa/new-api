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
  username = try(
    tencentcloud_kubernetes_cluster_endpoint.main.user_name,
    ""
  )
  password = try(
    tencentcloud_kubernetes_cluster_endpoint.main.password,
    ""
  )
  # TKE 集群 API Server 使用自签名证书，跳过 TLS 验证
  # 由于 endpoint 来源于 Terraform 创建的 tencentcloud_kubernetes_cluster_endpoint 资源，
  # 链路可信，跳过 TLS 验证是安全的
  insecure = true
}
