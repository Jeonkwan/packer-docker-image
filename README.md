# packer-docker-image

## How to build?

```Bash
# Building the foundation image, allow to run ansible, but not running ansible
packer build -only "foundation.*" .

# Building the final image, running ansible
packer build -only "final.*" .
```
