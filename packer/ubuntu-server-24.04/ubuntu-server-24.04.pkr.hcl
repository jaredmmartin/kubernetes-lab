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
    "linux /casper/vmlinuz <wait5>",
    "autoinstall quiet fsck.mode=skip noprompt <wait5>",
    "net.ifnames=0 biosdevname=0 systemd.unified_cgroup_hierarchy=1 <wait5>",
    "ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" <wait5>",
    "---<enter><wait5>",
    "initrd /casper/initrd<enter><wait5>",
    "boot<enter>"
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
  iso_checksum = "file:https://releases.ubuntu.com/24.04.3/SHA256SUMS"
  iso_url = "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso"
  memory = 4096
  shutdown_command = "sudo shutdown -h now"
  ssh_handshake_attempts = 30
  ssh_password = "vagrant"
  ssh_read_write_timeout = "60s"
  ssh_timeout = "60m"
  ssh_username = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--rtcuseutc", "on"]
  ]
  vm_name = "ubuntu-server-22-04"
}

build {
  post-processor "vagrant" {
    architecture = "amd64"
    output = "ubuntu-server-24.04.box"
  }
  provisioner "ansible" {
    extra_arguments = [
      "--scp-extra-args",
      "'-O'"
    ]
    playbook_file   = "files/main.yml"
  }
  sources = ["source.virtualbox-iso.image"]
}
