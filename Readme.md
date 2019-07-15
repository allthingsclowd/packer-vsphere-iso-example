# Example Packer configuration files for building Ubuntu 18.04 Server Image for VMware ESXi 6.7 platform

All examples were run on a MacOS laptop

``` text
System Software Overview:

  System Version:	macOS 10.14.5 (18F132)
  Kernel Version:	Darwin 18.6.0
```

Packer version 1.3.5 was used as the brew install of Packer at the time of writing defaulted to version 1.4.1 and this caused [false ISO download issues](https://github.com/hashicorp/packer/issues/7622) when working with VMware/vCenter 6.7.

This is the error I keep getting when using Packer 1.4.0 - 1.4.2 :

``` text
==> vsphere-iso: Retrieving ISO
    vsphere-iso: Error downloading: open : no such file or directory
==> vsphere-iso: ISO download failed.
Build 'vsphere-iso' errored: ISO download failed.

==> Some builds didn't complete successfully and had errors:
--> vsphere-iso: ISO download failed.

==> Builds finished but no artifacts were created.
```

## Prerequisite to running the build process:

- Clone this repository

``` bash
git clone git@github.com:allthingsclowd/packer-vsphere-iso-example.git 
```

- Configure the `.variables` file _[Note: Ensure to add this file to your .gitignore or keep it outside your repository to avoid accidentally uploading passwords to your repository]_

``` json
{
    "vcenter_server":"YOUR VCENTRE IP ADDRESS",
    "username":"administrator@vsphere.local",
    "password":"VCENTRE PASSWORD",
    "datastore":"datastore1",
    "folder": "/vm/_Templates",
    "host":"ESXi IP ADDRESS",
    "cluster": "",
    "network": "VM Network",
    "resource_pool": "",
    "ssh_username": "grazzer",
    "ssh_password": "grazzer"
}
```

- Copy your public ssh key that you'll use to access the VM remotely to the packer directory and call it `id_rsa.pub`

- Change into the packer directory

``` bash
cd packer
```

- Download [packer version 1.3.5](https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_darwin_amd64.zip)

```bash
wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_darwin_amd64.zip
unzip packer_1.3.5_darwin_amd64.zip
chmod +x packer
```

- Download the [vsphere-iso builder plugin](https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v2.3/packer-builder-vsphere-iso.macos) and rename as follows

``` bash
wget https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v2.3/packer-builder-vsphere-iso.macos
mv packer-builder-vsphere-iso.macos packer-builder-vsphere-iso
chmod +x packer-builder-vsphere-iso
```

## Example command used to build a server image template

``` bash
./packer build -force -var-file=../.variables server.json
```

