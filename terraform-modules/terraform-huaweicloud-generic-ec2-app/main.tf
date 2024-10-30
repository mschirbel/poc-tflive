### DATA SOURCES ###
data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = var.performance_type # non-called var
  cpu_core_count    = var.cpu_core_count
  memory_size       = var.memory_size
}

data "huaweicloud_images_image" "myimage" {
  name        = var.huaweicloud_images_image
  most_recent = var.most_recent
}

### RESOURCES ###
resource "huaweicloud_compute_instance" "basic" {
  name               = var.name
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.ids[0]
  security_group_ids = [var.secgroup_id]
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]

  network {
    uuid = var.huaweicloud_vpc_subnet_ids
  }
}

resource "huaweicloud_obs_bucket" "this" {
  count = var.create_obs_bucket ? 1 : 0
  bucket = var.name
  acl    = var.acl
}

resource "huaweicloud_rds_instance" "instance" {
  count = var.create_rds_instance ? 1 : 0

  name              = var.name
  flavor            = var.rds_flavor
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.secgroup_id
  availability_zone = [var.availability_zone]

  db {
    type     = "PostgreSQL"
    version  = "12"
    password = var.postgreSQL_password
  }

  volume {
    type = "ULTRAHIGH"
    size = 100
  }

  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }
}