packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "image" {
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud;",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
  boot_wait = "5s"
  cd_files = [
    "./files/meta-data",
    "./files/user-data"
  ]
  cd_label = "cidata"
  cpus = 4
  disk_size = "40960"
  guest_os_type = "Ubuntu_64"
  headless = true
  http_directory = "files"
  iso_checksum = "none"
  iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
  memory = 4096
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_handshake_attempts = 20
  ssh_password = "vagrant"
  ssh_timeout = "60m"
  ssh_username = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--rtcuseutc", "on"]
  ]
  vm_name = "ubuntu"
}

build {
  sources = ["source.virtualbox-iso.image"]

  provisioner "ansible" {
    playbook_file   = "files/main.yml"
  }

  post-processor "vagrant" {
    architecture = "amd64"
    output = "../boxes/ubuntu-server-22.04.box"
  }
}
