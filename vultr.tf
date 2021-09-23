provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 700
  retry_limit = 3
}

data "vultr_os" "custom" {
  filter {
    name   = "name"
    values = ["Custom"]
  }
}

resource "vultr_startup_script" "alpine_boot_script" {
  name   = "alpine_boot_script"
  type   = "pxe"
  script = base64encode(replace(file("./config/alpine-boot.ipxe"), "%KEYS_URL%", var.ssh_public_key_url))
}

resource "vultr_instance" "k3s_server" {
  label            = "k3s-s"
  os_id            = data.vultr_os.custom.id
  script_id        = vultr_startup_script.alpine_boot_script.id
  plan             = "vhf-1c-1gb"
  region           = "nrt"
  enable_ipv6      = true
  activation_email = false

  provisioner "file" {
    connection {
      type        = "ssh"
      host        = self.main_ip
      private_key = file(pathexpand(var.ssh_private_key))
      user        = "root"
    }
    source      = "./config/setup-alpine.conf"
    destination = "/root/setup-alpine.conf"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.main_ip
      private_key = file(pathexpand(var.ssh_private_key))
      user        = "root"
    }
    inline = [
      "yes | setup-alpine -ef /root/setup-alpine.conf",
      "mount /dev/vda3 /mnt",
      "cp -r /root/.ssh /mnt/root/.ssh",
      "sed -i \"/Port /c\\Port 2223\" /mnt/etc/ssh/sshd_config",
      "umount /mnt",
      "reboot",
    ]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.main_ip
      private_key = file(pathexpand(var.ssh_private_key))
      user        = "root"
      port        = 2223
    }
    script = "./config/setup-alpine-k3s.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.main_ip
      private_key = file(pathexpand(var.ssh_private_key))
      user        = "root"
      port        = 2222
    }
    inline = [
      "curl -sfL https://get.k3s.io | sh -",
    ]
  }
}
