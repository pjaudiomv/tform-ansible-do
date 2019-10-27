output "public_ip" {
  value = digitalocean_droplet.pjoyce-photos.ipv4_address
}

output "name" {
  value = digitalocean_droplet.pjoyce-photos.name
}
