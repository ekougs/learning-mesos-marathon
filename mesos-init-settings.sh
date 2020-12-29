#! /bin/bash

hostname -I | cut -d' ' -f1 > /etc/mesos-master/advertise_ip
wait-for-it --timeout=6000 mesos.bytesb8.io:2181
