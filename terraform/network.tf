resource "digitalocean_vpc" "private_network" {
  name     = "k3s-private-network"
  region   = var.region
  ip_range = "192.168.32.0/24"
}

resource "digitalocean_firewall" "k3s" {
  name = "k3s-firewall"
  tags = ["k3s-cluster"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0", "192.168.32.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  #   outbound_rule {
  #     protocol              = "tcp"
  #     port_range            = "80"
  #     destination_addresses = ["0.0.0.0/0", "::/0"]
  #   }

  #   outbound_rule {
  #     protocol              = "tcp"
  #     port_range            = "443"
  #     destination_addresses = ["0.0.0.0/0", "::/0"]
  #   }

  #   outbound_rule {
  #     protocol              = "tcp"
  #     port_range            = "53"
  #     destination_addresses = ["0.0.0.0/0", "::/0"]
  #   }

  #   outbound_rule {
  #     protocol              = "udp"
  #     port_range            = "53"
  #     destination_addresses = ["0.0.0.0/0", "::/0"]
  #   }

  #   outbound_rule {
  #     protocol              = "tcp"
  #     port_range            = "6443"
  #     destination_addresses = ["192.168.32.0/24"]
  #   }

}