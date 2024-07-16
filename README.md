# packer-docker-image

## How to build?

```Bash
# Building the foundation image, allow to run ansible, but not running ansible
packer build -only "foundation.*" .

# Building the final image, running ansible
packer build -only "final.*" .
```

## How to encrypt password?

Using ansible vault

1. you will need a vault password or a vault password file, e.g. `sample_vault_password`
2. the content of the vault password file is just a password string you can defined.
3. you will also need a YAML file that containing variable key-value pairs for your actual credentials, e.g. `sample_credentials.yml`
4. run `ansible-vault` command to encrypt the actual credential file.

```bash
ansible-vault encrypt \
    --vault-pass-file sample_vault_password \
    sample_credentials.yml
```

