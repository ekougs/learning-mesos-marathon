================================
 Mesos experimentation
================================

Build the base Mesos image locally
==================================

::
    packer build -only=docker.centos-7-mesos-marathon mesos-marathon.pkr.hcl

Build the base Mesos image on DigitalOcean
==========================================

::
    packer build -only=digitalocean.centos-7-mesos-marathon mesos-marathon.pkr.hcl