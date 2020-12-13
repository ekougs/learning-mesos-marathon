variable "cloudflare_zone_id" {
}

variable "do_token" {
}

variable "cf_api_token" {
}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

data "digitalocean_droplet_snapshot" "mesos-marathon" {
  name = "centos-7-mesos-marathon"
}

resource "digitalocean_droplet" "mesos-marathon" {
  image  = data.digitalocean_droplet_snapshot.mesos-marathon.id
  name   = "mesos-marathon"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["50:3e:72:33:12:b6:8c:2f:ac:fe:b7:7d:01:90:33:24", "a2:57:ce:b6:2a:56:6b:d2:4c:76:4f:49:0d:fd:b4:76"]
}

resource "cloudflare_record" "mesos-leader-A" {
    zone_id = var.cloudflare_zone_id
    name    = "mesos"
    value   = digitalocean_droplet.mesos-marathon.ipv4_address
    type    = "A"
    ttl     = 3600
}

resource "cloudflare_record" "mesos-agent-marathon-A" {
    zone_id = var.cloudflare_zone_id
    name    = "marathon"
    value   = digitalocean_droplet.mesos-marathon.ipv4_address
    type    = "A"
    ttl     = 3600
}
