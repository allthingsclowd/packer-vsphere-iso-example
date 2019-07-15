#!/usr/bin/env bash

# TODO: Move all versions upto to here for easier mgmt
consul_version=1.6.0-beta1
vault_version=1.2.0-beta2
nomad_version=0.10.0-connect1
terraform_version=0.12.4
consul_template_version=0.20.0
env_consul_version=0.8.0
golang_version=1.12.1
inspec_package_url=https://packages.chef.io/files/stable/inspec/3.9.0/ubuntu/18.04/inspec_3.9.0-1_amd64.deb
inspec_package=`basename ${inspec_package_url}`

install_hashicorp_binaries () {

    # check consul binary
    [ -f /usr/local/bin/consul ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f consul_${consul_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
        }
        sudo unzip consul_${consul_version}_linux_amd64.zip
        sudo chmod +x consul
        sudo rm consul_${consul_version}_linux_amd64.zip
        popd
    }

    # check consul-template binary
    [ -f /usr/local/bin/consul-template ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f consul-template_${consul_template_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/consul-template/${consul_template_version}/consul-template_${consul_template_version}_linux_amd64.zip
        }
        sudo unzip consul-template_${consul_template_version}_linux_amd64.zip
        sudo chmod +x consul-template
        sudo rm consul-template_${consul_template_version}_linux_amd64.zip
        popd
    }

    # check envconsul binary
    [ -f /usr/local/bin/envconsul ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f envconsul_${env_consul_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/envconsul/${env_consul_version}/envconsul_${env_consul_version}_linux_amd64.zip
        }
        sudo unzip envconsul_${env_consul_version}_linux_amd64.zip
        sudo chmod +x envconsul
        sudo rm envconsul_${env_consul_version}_linux_amd64.zip
        popd
    }

    # check vault binary
    [ -f /usr/local/bin/vault ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f vault_${vault_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip
        }
        sudo unzip vault_${vault_version}_linux_amd64.zip
        sudo chmod +x vault
        sudo rm vault_${vault_version}_linux_amd64.zip
        popd
    }

    # check terraform binary
    [ -f /usr/local/bin/terraform ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f terraform_${terraform_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip
        }
        sudo unzip terraform_${terraform_version}_linux_amd64.zip
        sudo chmod +x terraform
        sudo rm terraform_${terraform_version}_linux_amd64.zip
        popd
    }

    # check for nomad binary
    [ -f /usr/local/bin/nomad ] &>/dev/null || {
        pushd /usr/local/bin
        [ -f nomad_${nomad_version}_linux_amd64.zip ] || {
            sudo wget -q https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip
        }
        unzip nomad_${nomad_version}_linux_amd64.zip
        chmod +x nomad
        sudo rm nomad_${nomad_version}_linux_amd64.zip
        popd
    }
}

install_chef_inspec () {
    
    [ -f /usr/bin/inspec ] &>/dev/null || {
        pushd /tmp
        [ -f ${inspec_package} ] || {
            sudo wget -q ${inspec_package_url}
        }
        sudo apt-get install -y ./${inspec_package}
        sudo rm ${inspec_package}
        popd
    }    

}

apt-get clean
apt-get update
apt-get upgrade -y

# Update to the latest kernel
apt-get install -y linux-generic linux-image-generic linux-server

# Hide Ubuntu splash screen during OS Boot, so you can see if the boot hangs
apt-get remove -y plymouth-theme-ubuntu-text
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
update-grub

apt-get install -y wget -q unzip git redis-server nginx lynx jq curl net-tools

# disable services that are not used by all hosts
sudo systemctl stop redis-server
sudo systemctl disable redis-server
sudo systemctl stop nginx
sudo systemctl disable nginx

which /usr/local/go &>/dev/null || {
    mkdir -p /tmp/go_src
    pushd /tmp/go_src
    [ -f go${golang_version}.linux-amd64.tar.gz ] || {
        wget -qnv https://dl.google.com/go/go${golang_version}.linux-amd64.tar.gz
    }
    tar -C /usr/local -xzf go${golang_version}.linux-amd64.tar.gz
    popd
    rm -rf /tmp/go_src
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
}

install_hashicorp_binaries
install_chef_inspec

# Reboot with the new kernel
shutdown -r now
sleep 60

exit 0

