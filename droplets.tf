resource "digitalocean_droplet" "control_plane" {
  name     = "k3s-control-plane"
  image    = var.image
  size     = "s-2vcpu-4gb"
  region   = var.region
  vpc_uuid = digitalocean_vpc.private_network.id
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  tags     = ["k3s-cluster"]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "15m"
  }

  user_data = templatefile("${path.module}/templates/setup-control-plane.sh", {
    k3s_token = random_password.k3s_token.result
  })

  # provisioner "remote-exec" {
  #   inline = [
  #     "apt-get update",
  #     "apt-get -y install curl",

  #     "curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --token ${random_password.k3s_token.result} --tls-san ${self.ipv4_address}",

  #     "until systemctl is-active --quiet k3s; do sleep 2; done",
  #     "until kubectl get nodes 2>/dev/null; do sleep 2; done"
  #   ]
  # }

}

resource "digitalocean_droplet" "worker" {
  name       = "k3s-worker"
  image      = var.image
  size       = "s-2vcpu-2gb"
  region     = var.region
  vpc_uuid   = digitalocean_vpc.private_network.id
  ssh_keys   = [data.digitalocean_ssh_key.default.id]
  tags       = ["k3s-cluster"]
  depends_on = [digitalocean_droplet.control_plane]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "15m"
  }

  user_data = templatefile("${path.module}/templates/setup-worker.sh", {
    k3s_token        = random_password.k3s_token.result
    control_plane_ip = digitalocean_droplet.control_plane.ipv4_address_private
  })
  # provisioner "remote-exec" {
  #   inline = [
  #     "apt-get update",
  #     "apt-get -y install curl",

  #     "until curl -k https://${digitalocean_droplet.control_plane.ipv4_address_private}:6443/ping; do sleep 5; done",

  #     "curl -sfL https://get.k3s.io | K3S_TOKEN=\"${random_password.k3s_token.result}\" K3S_URL=\"https://${digitalocean_droplet.control_plane.ipv4_address_private}:6443\" sh -"
  #   ]
  # }

}