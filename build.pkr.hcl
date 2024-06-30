# Packer configuration for building a Docker image
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "base" {
  image  = "ubuntu:latest"
  commit = true
}


build {
  name = "alpine-python"
  sources = [
    "source.docker.base"
  ]

  provisioner "ansible" {
    user = "ubuntu"
    playbook_file = "./ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_PIPELINING=true", "ANSIBLE_SSH_PIPELINING=true"]
    use_proxy = false
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

