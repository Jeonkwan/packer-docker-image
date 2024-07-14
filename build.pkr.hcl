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

variable "foundation_image_name" {
  default = "ubuntu-python"
}

variable "foundation_image_tags" {
  type = list(string)
  default = [
    "latest"
  ]
}

variable "final_image_name" {
  type    = string
  default = "ubuntu-python-final"
}

variable "final_image_tags" {
  type = list(string)
  default = [
    "latest"
  ]
}

variable "default_image_tag" {
  type    = string
  default = "latest"
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
  name = "foundation"
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

  post-processor "docker-tag" {
    repository = var.foundation_image_name
    tags       = var.foundation_image_tags
  }
}

source "docker" "foundation" {
  image  = "${var.foundation_image_name}:${var.default_image_tag}"
  commit = true
  pull = false
  run_command = [
    "-d",
    "-i",
    "-t",
    "--rm",
    "--entrypoint=/bin/bash",
    "--name",
    var.ansible_host,
    "${var.foundation_image_name}:${var.default_image_tag}"
  ]
}

build {
  name = "final"
  sources = [
    "source.docker.foundation"
  ]

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
    repository = var.final_image_name
    tags       = var.final_image_tags
  }
}