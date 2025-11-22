resource "local_file" "ansible_inventory" {
  content = <<-EOT
        [control_plane]
        ${digitalocean_droplet.control_plane.name} ansible_host=${digitalocean_droplet.control_plane.ipv4_address}

        [worker]
        ${digitalocean_droplet.worker.name} ansible_host=${digitalocean_droplet.worker.ipv4_address}

        [all:vars]
        ansible_user=root
        ansible_ssh_private_key_file=~/.ssh/id_ed25519_terraform_do
    EOT

  filename = "${path.module}/inventory.ini"
}

resource "null_resource" "run_ansible" {
  depends_on = [
    digitalocean_droplet.control_plane,
    digitalocean_droplet.worker,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = <<-EOT
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${local_file.ansible_inventory.filename} \
            ${path.module}/../ansible/k3s.yaml \
            --extra-vars "k3s_token=${random_password.k3s_token.result} control_plane_ip=${digitalocean_droplet.control_plane.ipv4_address}"
        EOT
  }
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [null_resource.run_ansible]

  provisioner "local-exec" {
    command = <<-EOT
            scp -o StrictHostKeyChecking=no \
            -i ~/.ssh/id_ed25519_terraform_do \
            root@${digitalocean_droplet.control_plane.ipv4_address}:/etc/rancher/k3s/k3s.yaml \
            ./kubeconfig
            
            sed -i 's/127.0.0.1/${digitalocean_droplet.control_plane.ipv4_address}/g' ./kubeconfig
        EOT
  }
}