# Packer configuration for building a Docker image
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}
packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "ansible_host" {
  default = "packer-build-tmp"
}

variable "ansible_connection" {
  default = "docker"
}

variable "base_image" {
  default = "ubuntu:focal"
}

source "docker" "base" {
  image  = var.base_image
  commit = true
  run_command = [
    "-d",
    "-i",
    "-t",
    "--rm",
    "--entrypoint=/bin/bash",
    "--name",
    var.ansible_host,
    var.base_image
  ]
}


build {
  sources = [
    "source.docker.base"
  ]

  provisioner "shell" {
    env = {
      TZ              = "UTC"
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get -y update",
      "apt-get install -y python3"
    ]
  }

  provisioner "ansible" {
    # command       = "/usr/local/py-utils/bin/ansible-playbook"
    playbook_file = "./ansible/playbook.yml"
    extra_arguments = [
      "-vvv",
      "--extra-vars",
      "ansible_user=root ansible_host=${var.ansible_host} ansible_connection=${var.ansible_connection}"
    ]
  }

  post-processor "docker-tag" {
    repository = "ubuntu-python"
    tags       = ["latest"]
  }
}

