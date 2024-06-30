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
  image  = "alpine:latest"
  commit = true
}


build {
  name = "alpine-python"
  sources = [
    "source.docker.base"
  ]

  provisioner "shell" {
    environment_vars = [
      "MSG=hello world",
    ]
    inline = [
      "echo \"MSG is $MSG\" > example.txt",
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "MSG=hello world",
    ]
    inline = [
      "echo \"MSG is $MSG\" > abc.txt",
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "MSG=hello world",
    ]
    inline = [
      "cat abc.txt > abc_copy.txt",
    ]
  }

  post-processor "docker-tag" {
    repository = "alpine-python"
    tags       = ["latest"]
  }
}

