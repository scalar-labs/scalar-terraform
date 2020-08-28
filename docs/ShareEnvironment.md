# How to share environment with others

This explanation is for multiple person operating in the same environment.

## Get a public/private key-pair from the person who built the environment

:memo: Also need all the tfsatte files when using `local` backend

## Update the tfstate in network module

- Fix key path in example.tfvars

  ```
  public_key_path = "./example_key.pub"

  private_key_path = "./example_key"
  ```

- Update tfsatte

  ```sh
  cd example/aws/network
  terraform init
  terraform refresh -var-file=example.tfvars
  ```

## Update the tfstate of the cassandra, scalardl and monitor modules

Update `private_key_path` in `data.terraform_remote_state.network`

```
cd example/aws/[cassandra|scalardl|monitor]
terraform init
terraform refresh -var-file=example.tfvars
```
