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


source "docker" "base" {
  image  = "ubuntu:focal"
  commit = true
  run_command = ["-d", "-i", "-t", "--rm", "--entrypoint=/bin/bash", "{{.Image}}"]
}


build {
  # name = "ubuntu-python"
  sources = [
    "source.docker.base"
  ]

  provisioner "file" {
    source = "./ansible/playbook.yml"
    destination = "/root/playbook.yml"
  }

  provisioner "shell" {
    inline = [
        "apt-get -y update",
        "apt-get install -y software-properties-common",
        "apt-add-repository ppa:ansible/ansible",
        "apt-get -y update",
        "apt-get install --no-install-recommends -y ansible",
        "apt-get clean",
        "rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*"
    ]
  }


  provisioner "ansible" {
    playbook_file    = "./ansible/playbook.yml"
    extra_arguments = [
      "ansible_host=default",
      "ansible_connection=docker"
    ]
  }

  post-processor "docker-tag" {
    repository = "ubuntu-python"
    tags       = ["latest"]
  }
}

