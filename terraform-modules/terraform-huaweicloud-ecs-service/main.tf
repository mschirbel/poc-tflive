module "ecs_service" {
  source = "terraform-huaweicloud-modules/terraform-huaweicloud-ecs"

  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids

  instance_name            = var.instance_name
  instance_flavor_id       = var.flavor_id
  instance_image_id        = var.image_id
  system_disk_type         = var.system_disk_type
  system_disk_size         = var.system_disk_size
  admin_password           = random_password.password.result
  data_disks_configuration = var.data_disks_configuration
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "huaweicloud_csms_secret" "this" {
  name        = "ecs_password"
  secret_text = jsonencode({
    password = random_password.password.result
  })
}