# Recommended Practices of Operation with Scalar DL Orchestration Tool

This guide shows recommended practices of operation with our terraform-based Scalar DL orchestration tool.

## Review a generated plan carefully

As [the terraform doc](https://learn.hashicorp.com/terraform/development/running-terraform-in-automation#automated-workflow-overview) describes, it is always recommended to review a generated plan carefully to see if all planned changes are as expected and acceptable.
This is because terraform might produce a wrong plan for some reason such as bugs in our modules or terraform itself.
Also, it is usually a good practice to apply changes one by one to be able to easily review.

## Use the same versioned orchestration tool

Different versions could produce different results so it is recommended to use the same version if possible.
If the tool needs to be upgraded for some reason, please review a generated plan with extra care.

