Contains configuration for [terraform](https://www.terraform.io) to setup [k3s](https://k3s.io) cluster on [vultr](https://www.vultr.com) instances running [alpine linux](https://www.alpinelinux.org).

Create file `terraform.tfvars` in main folder:
```
k3s_token          = "super_secret_token"
ssh_private_key    = "~/.ssh/id_rsa"
ssh_public_key_url = "https://github.com/cornelfh.keys"
vultr_api_key      = "insert_your_vultr_api_key_here"
cloudflare_email       = ""
cloudflare_api_key     = ""
cloudflare_domain_name = ""
subdomains             = ["www"]
```
