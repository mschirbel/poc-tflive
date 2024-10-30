variable "huaweicloud_vpc_subnet_ids" {
    type = list(string)
}

variable "secgroup_id" {
    type = string
}

variable "huaweicloud_images_image" {
    type = string
    default = "Ubuntu 18.04 server 64bit"
}

variable "most_recent" {
    type = bool
    default = true
}

variable "create_obs_bucket" {
    type = bool
    default = false
}


variable "performance_type" {
    type = string
    default = "normal"
}

variable "acl" {
    type = string
    default = "private"
}

variable "cpu_core_count" {
    type = number
    default = 2
}

variable "memory_size" {
    type = number
    default = 4
}