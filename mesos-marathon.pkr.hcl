# This file was autogenerated by the BETA 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/from-1.5/variables#type-constraints for more info.
# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
source "digitalocean" "centos-7-mesos-marathon-main" {
  image         = "centos-7-x64"
  region        = "fra1"
  size          = "512mb"
  snapshot_name = "centos-7-mesos-marathon-main"
  ssh_username  = "root"
  tags          = ["centos-7-x64", "mesos", "marathon", "main"]
}

source "digitalocean" "centos-7-mesos-marathon-agent" {
  image         = "centos-7-x64"
  region        = "fra1"
  size          = "512mb"
  snapshot_name = "centos-7-mesos-marathon-agent"
  ssh_username  = "root"
  tags          = ["centos-7-x64", "mesos", "marathon", "agent"]
}

source "docker" "centos-7-mesos-marathon-main" {
  image       = "centos:7"
  export_path = "centos-7-mesos-marathon-main.tar"
}

source "docker" "centos-7-mesos-marathon-agent" {
  image       = "centos:7"
  export_path = "centos-7-mesos-marathon-agent.tar"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  sources = ["source.digitalocean.centos-7-mesos-marathon-main", "source.digitalocean.centos-7-mesos-marathon-agent", "source.docker.centos-7-mesos-marathon-main", "source.docker.centos-7-mesos-marathon-agent"]

  provisioner "shell" {
    inline = ["yum update -y", "yum install -y epel-release", "yum install -y ansible"]
  }

  provisioner "file" {
    source = "mesos-init-settings.sh"
    destination = "/usr/local/bin/mesos-init-settings.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "playbook-mesos-base.yml"
  }

  provisioner "ansible-local" {
    playbook_file = "playbook-mesos-marathon.yml"
  }

  provisioner "ansible-local" {
    playbook_file = "playbook-mesos-marathon-main.yml"
    only       = ["docker.centos-7-mesos-marathon-main", "digitalocean.centos-7-mesos-marathon-main"]
  }

  provisioner "ansible-local" {
    playbook_file = "playbook-mesos-marathon-agent.yml"
    only       = ["docker.centos-7-mesos-marathon-agent", "digitalocean.centos-7-mesos-marathon-agent"]
  }

  post-processor "docker-import" {
    repository = "ekougs/mesos-marathon"
    tag        = "0.1"
    only       = ["docker.centos-7-mesos-marathon-main"]
  }

  post-processor "docker-import" {
    repository = "ekougs/mesos-marathon-agent"
    tag        = "0.1"
    only       = ["docker.centos-7-mesos-marathon-agent"]
  }
}
