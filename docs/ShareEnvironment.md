# How to share environment with others

This explanation is for multiple person operating in the same environment.

## Get a public/private key-pair from the person who built the environment

:memo: Also need all the tfsatte files when using `local` backend

## Update the tfstate of the network module

- Fix key_path of `example.tfvars` in your local

  ```
  public_key_path = "./example_key.pub"

  private_key_path = "./example_key"
  ```

- Update the output value `private_key_path` of tfsate

  ```
  cd example/[aws|azure]/network
  terraform init
  terraform refresh -var-file=example.tfvars
  ```

## Update the tfstate of the cassandra, scalardl and monitor modules

- Update the `private_key_path` of `data.terraform_remote_state.network` in each tfstate

  ```
  cd example/[aws|azure]/[cassandra|scalardl|monitor]
  terraform init
  terraform refresh -var-file=example.tfvars
  ```
