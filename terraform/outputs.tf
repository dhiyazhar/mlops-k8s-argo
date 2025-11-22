output "control_plane_public_ip" {
  value = digitalocean_droplet.control_plane.ipv4_address
}

output "control_plane_private_ip" {
  value = digitalocean_droplet.control_plane.ipv4_address_private
}

output "worker_public_ip" {
  value = digitalocean_droplet.worker.ipv4_address
}

output "k3s_token" {
  value     = random_password.k3s_token.result
  sensitive = true
}

output "kubeconfig_command" {
  value = "export KUBECONFIG=${path.module}/kubeconfig"
}