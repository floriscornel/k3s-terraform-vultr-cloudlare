Contains configuration for [terraform](https://www.terraform.io) to setup [k3s](https://k3s.io) cluster on [vultr](https://www.vultr.com) instances running [alpine linux](https://www.alpinelinux.org) and using [cloudflare](https://www.cloudflare.com) to configure DNS.


Create file `terraform.tfvars` in main folder:
```
k3s_token = ""
ssh_key_name = ""
vultr_api_key = ""
cloudflare_email = ""
cloudflare_api_key = ""
cloudflare_domain_name = ""
subdomains = ["www", "subdomain"]
```
