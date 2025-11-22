resource "digitalocean_droplet" "control_plane" {
  name     = "k3s-control-plane"
  image    = var.image
  size     = "s-2vcpu-4gb"
  region   = var.region
  vpc_uuid = digitalocean_vpc.private_network.id
  ssh_keys = [data.digitalocean_ssh_key.main.id]
  tags     = ["k3s-cluster"]
}

resource "digitalocean_droplet" "worker" {
  name       = "k3s-worker"
  image      = var.image
  size       = "s-2vcpu-2gb"
  region     = var.region
  vpc_uuid   = digitalocean_vpc.private_network.id
  ssh_keys   = [data.digitalocean_ssh_key.main.id]
  tags       = ["k3s-cluster"]
  depends_on = [digitalocean_droplet.control_plane]
}

data "digitalocean_ssh_key" "main" {
  name = var.ssh_key
}