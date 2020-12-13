terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.13.2"
  }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.2.0"
   }
  }
  required_version = ">= 0.13"
}
