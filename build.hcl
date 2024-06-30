# Packer configuration for building a Docker image
packer {
  # Name of the build
  name = "alpine-python-app"

  # Builder type: Docker
  builder {
    type = "docker"

    # Docker image to use as the base image
    image = "alpine:latest"

    # Build context directory
    context = "build"

    # Dockerfile to use for building the image
    source = "Dockerfile"

    # Dockerfile build arguments
    build_args = {
      PYTHON_VERSION = "3.10"
    }
  }

  # Provisioner type: Ansible
  provisioner "ansible" {
    # Ansible playbook to run
    playbook_file = "ansible/playbook.yml"

    # Ansible inventory file
    inventory_file = "ansible/hosts"

    # Ansible connection type
    connection = "docker"

    # Ansible user to connect as
    user = "root"

    # Ansible environment variables
    env = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
    }
  }
}
