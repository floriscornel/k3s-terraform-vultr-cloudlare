provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 700
  retry_limit = 3
}

data "vultr_snapshot" "alpine_snap" {
  filter {
    name   = "description"
    values = ["alpine-small.raw"]
  }
}

resource "vultr_instance" "k3s_server" {
  label            = "devops-k3s-s"
  snapshot_id      = data.vultr_snapshot.alpine_snap.id
  plan             = "vhf-1c-2gb"
  region           = "nrt"
  enable_ipv6      = true
  activation_email = false

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "alpine"
      host     = self.main_ip
      port     = 22
    }
    script = "config/setup-alpine-k3s.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_ed25519")
      host        = self.main_ip
      port        = 2222
    }
    inline = [
      "echo '${self.label}' > /etc/hostname",
      "hostname -F /etc/hostname",
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${var.k3s_token} sh -",
    ]
  }
}

resource "vultr_instance" "k3s_agent" {
  count            = 2
  label            = "devops-k3s-a${count.index}"
  snapshot_id      = data.vultr_snapshot.alpine_snap.id
  plan             = "vhf-1c-1gb"
  region           = "nrt"
  enable_ipv6      = true
  activation_email = false

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "alpine"
      host     = self.main_ip
      port     = 22
    }
    script = "config/setup-alpine-k3s.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_ed25519")
      host        = self.main_ip
      port        = 2222
    }
    inline = [
      "echo '${self.label}' > /etc/hostname",
      "hostname -F /etc/hostname",
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${var.k3s_token} K3S_URL=https://${vultr_instance.k3s_server.main_ip}:6443 sh -",
    ]
  }
}
