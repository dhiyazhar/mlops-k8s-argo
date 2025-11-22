variable "do_token" {}

variable "pvt_key" {}

variable "ssh_key" {
  type = string
}

variable "region" {
  type    = string
  default = "sgp1"
}

variable "image" {
  type    = string
  default = "ubuntu-24-04-x64"
}

variable "minio_root_user" {
  type      = string
  sensitive = true
}

variable "minio_root_password" {
  type      = string
  sensitive = true
}