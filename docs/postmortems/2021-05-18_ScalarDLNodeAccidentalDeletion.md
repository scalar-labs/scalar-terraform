# Postmortem of Accidentally Deleted Scalardl Node Replacement in Azure Production Simulated Environment

## Date

- When happned: 2021-05-18 11:34
- When detected: 2021-05-18 11:45
- When resolved: 2021-05-19 15:02

## Authors

- Boney Jacob

## Current status

- Resolved

## Summary

One of the Scalar DL nodes (`scalardl-blue-1`) was accidentally deleted in the Azure production simulated environment.

## Impact

The Azure PSIM environment generated the critical and warning alerts for `scalardl-blue-1` and PSIM continued testing with the other 2 `scalardl-blue` nodes.

## Root Causes

The `scalardl-blue-1` node was accidentally deleted by me.

## Trigger

Scalardl node replacement failed while trying to replace the node with current [Troubleshooting Guide](../TroubleshootingGuide.md).

Following are procedures to resolve the issue:

1. On the Azure portal, manually delete the orphaned osdisk `osdisk-scalar-blue-1`.

2. cd to the azure orchestration directory in [scalar-production-simulated-testing](https://github.com/scalar-labs/scalar-production-simulated-testing).
   
    ```console
    $ cd scalar-production-simulated-testing/terraform/azure/scalardl
    ```
   
3. Since the same PSIM directories have been used before, the following `terraform taint` command has been implemented without `terraform init`. 
   
    ```console
    $ terraform taint "module.scalardl.module.scalardl_blue.module.cluster.azurerm_virtual_machine.vm-linux[0]""
    $ terraform taint "module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.schema_loader_image[0]"
    $ terraform taint " module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_image[0]"
    $ terraform apply 
    ```
   
   The `scalardl-blue-1` node replacement failed due to the terraform version mismatch in the local machine(v0.14.7).
 
4. Downgraded the `terrafrom` local machine version to `v0.12.31`
   
5. Removed the `.terraform` directory from `scalar-production-simulated-testing/terraform/azure/scalardl`.
   
6. Executed `terraform init`

    ```console
    $ terraform init
    ```
   
    The `terraform init` command failed due to the terraform version mismatch on local machine.
   
    ```
    Error refreshing state: state snapshot was created by Terraform v0.14.7, which is newer than current v0.12.31; upgrade to Terraform v0.14.7 or greater to work with this state
    ```
   
7. Manually updated the terraform version in [scalardl terraform state snapshot file](https://psimtesting.blob.core.windows.net/tfstate/azure/scalardl/terraform.tfstate) which is located in azure blob storage.

8. Executed the following commands for initialize and refresh state file.

    ```console
    $ terraform init
    $ terraform refresh
    ```
   
9. Finally run the `apply` command and confirm what will happen, then answer `yes`.
   
    ```console
    $ terraform apply
    ```

   The `scalardl-blue-1` node replacement failed. In terraform plan contained unnecessary creation and replacement plans.

    ```
    Terraform will perform the following actions:
      # module.scalardl.module.envoy_provision.null_resource.docker_install[0] is tainted, so must be replaced
    -/+ resource "null_resource" "docker_install" {
          ~ id       = "7160518161730722835" -> (known after apply)
            triggers = {
                "triggers" = "114432071002630270"
            }
        }
      # module.scalardl.module.envoy_provision.null_resource.docker_install[1] is tainted, so must be replaced
    -/+ resource "null_resource" "docker_install" {
          ~ id       = "1917453256906746293" -> (known after apply)
            triggers = {
                "triggers" = "8403218909495813493"
            }
        }
      # module.scalardl.module.envoy_provision.null_resource.docker_install[2] is tainted, so must be replaced
    -/+ resource "null_resource" "docker_install" {
          ~ id       = "2834129031139583821" -> (known after apply)
            triggers = {
                "triggers" = "8573589660759708882"
            }
        }
      # module.scalardl.module.envoy_provision.null_resource.envoy_container[0] will be created
      + resource "null_resource" "envoy_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.envoy_provision.null_resource.envoy_container[1] will be created
      + resource "null_resource" "envoy_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.envoy_provision.null_resource.envoy_container[2] will be created
      + resource "null_resource" "envoy_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[1] is tainted, so must be replaced
    -/+ resource "null_resource" "docker_install" {
          ~ id       = "141025105550695811" -> (known after apply)
            triggers = {
                "triggers" = "8822314234222978051"
            }
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[2] is tainted, so must be replaced
    -/+ resource "null_resource" "docker_install" {
          ~ id       = "5782709652081109030" -> (known after apply)
            triggers = {
                "triggers" = "8733955099748061777"
            }
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_container[0] will be created
      + resource "null_resource" "scalardl_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_container[1] will be created
      + resource "null_resource" "scalardl_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_container[2] will be created
      + resource "null_resource" "scalardl_container" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_load[0] will be created
      + resource "null_resource" "scalardl_load" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_load[1] will be created
      + resource "null_resource" "scalardl_load" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_load[2] will be created
      + resource "null_resource" "scalardl_load" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_push[0] will be created
      + resource "null_resource" "scalardl_push" {
          + id       = (known after apply)
          + triggers = {
              + "scalar_image" = "136105436313401485"
              + "triggers"     = "6577216292729949662"
            }
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_push[1] will be created
      + resource "null_resource" "scalardl_push" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
      # module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_push[2] will be created
      + resource "null_resource" "scalardl_push" {
          + id       = (known after apply)
          + triggers = (known after apply)
        }
    Plan: 17 to add, 0 to change, 5 to destroy.
    ```

   Following are some of the logs that failed in the `terraform apply`

    ```
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[1] (remote-exec): TASK [common : Upgrade pip] ****************************************************
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[2] (remote-exec): fatal: [10.42.3.4]: FAILED! => {"changed": false, "msg": "Unable to find any of pip3 to use.  pip needs to be installed."}
           
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[2] (remote-exec): PLAY RECAP *********************************************************************
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[2] (remote-exec): 10.42.3.4                  : ok=12   changed=0    unreachable=0    failed=1    skipped=5    rescued=0    ignored=0
           
           
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[1] (remote-exec): fatal: [10.42.3.6]: FAILED! => {"changed": false, "msg": "Unable to find any of pip3 to use.  pip needs to be installed."}
           
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[1] (remote-exec): PLAY RECAP *********************************************************************
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.docker_install[1] (remote-exec): 10.42.3.6                  : ok=12   changed=0    unreachable=0    failed=1    skipped=5    rescued=0    ignored=0
    ```

## Resolution

A new Scalar DL node was added as `scalar-blue-1` by the steps below with the Scalar DL Orchestration Tools.

1. cd to the azure orchestration directory in [scalar-production-simulated-testing](https://github.com/scalar-labs/scalar-production-simulated-testing).

    ```console
    $ cd scalar-production-simulated-testing/terraform/azure
    ```

2. Configured the environment [Share Environment](../ShareEnvironment.md) document.

3. Executed `terraform destroy` command for removing `envoy-1` node
   
    ``` console
    terraform destroy -target='module.scalardl.module.envoy_cluster.azurerm_virtual_machine.vm-linux[0]'
    ```

4. Finally run the `apply` command and confirm what will happen, then answer `yes`.

    ```console
    $ terraform apply
    ```

## Detection

Alert manager properly detected that a node was down and posted an alert to #system-alert Slack channel.
