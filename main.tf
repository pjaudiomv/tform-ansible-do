variable "do_token" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  # You need to set this in your environment variable
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  token = var.do_token
}


resource "digitalocean_droplet" "pjoyce-photos" {
  # Obtain your ssh_key id number via your account. By running the following.
  # curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer TOKEN" "https://api.digitalocean.com/v2/account/keys" | jq --raw-output
  ssh_keys           = [25669333] # Key example
  image              = var.ubuntu
  region             = var.do_nyc1
  size               = "s-1vcpu-1gb"
  private_networking = true
  backups            = true
  ipv6               = true
  name               = "mywebserver-ams3"

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
    ]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      private_key = file("~/.ssh/id_rsa")
      user        = "root"
      timeout     = "2m"
    }
  }
}

resource "digitalocean_domain" "pjoyce-photos" {
  name       = "www.pjoyce.photos"
  ip_address = digitalocean_droplet.pjoyce-photos.ipv4_address
}

resource "digitalocean_record" "pjoyce-photos" {
  domain = digitalocean_domain.pjoyce-photos.name
  type   = "A"
  name   = "pjoyce-photos"
  value  = digitalocean_droplet.pjoyce-photos.ipv4_address
}
