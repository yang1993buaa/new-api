# ============================================================
# 云数据库 PostgreSQL
# ============================================================
resource "tencentcloud_postgresql_instance" "main" {
  name              = "new-api-pg"
  availability_zone = var.availability_zone
  charge_type       = "POSTPAID_BY_HOUR"
  vpc_id            = tencentcloud_vpc.main.id
  subnet_id         = tencentcloud_subnet.db.id
  db_major_version  = "15"
  root_password     = var.db_password
  charset           = "UTF8"
  cpu               = 1
  memory            = 2 # 2GB
  storage           = var.db_storage
  security_groups   = [tencentcloud_security_group.db.id]

  tags = var.tags

  timeouts {
    create = "30m"
    update = "30m"
  }
}

# 注意：tencentcloud_postgresql_database 资源不受 Provider 支持
# 数据库 new_api 需要在首次部署后手动创建，或通过 provisioner 执行：
#   CREATE DATABASE new_api;
# new-api 应用在启动时如果数据库不存在会自动创建表结构（GORM AutoMigrate）

# ============================================================
# 云数据库 Redis
# ============================================================
resource "tencentcloud_redis_instance" "main" {
  name              = "new-api-redis"
  availability_zone = var.availability_zone
  type_id           = 8 # Redis 5.0 标准版（支持按量付费）
  mem_size          = var.redis_mem_size
  password          = var.redis_password
  vpc_id            = tencentcloud_vpc.main.id
  subnet_id         = tencentcloud_subnet.db.id
  security_groups   = [tencentcloud_security_group.db.id]
  charge_type       = "POSTPAID"

  tags = var.tags
}
