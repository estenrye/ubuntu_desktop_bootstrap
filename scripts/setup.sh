#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
mkdir -p /home/vagrant/.ssh
curl https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant > /home/vagrant/.ssh/id_rsa

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic