# Adding Tags to Resources

scalar-terraform provides a feature to add arbitrary tags to resources created.

Sometimes it is useful to add tags to cloud resources.

* Label metadata such as the owner and the environment
* Organize billing to summerize the system-wide costs

At present, this feature only supports AWS.

## Setting Tags

In example.tfvars file in `network` module, you can add as many tags as needed in the `custom_tags` variable.
The tags specified here will be applied to all resources created by other modules that reference this module's output.

```
custom_tags = {
  Environment = "production"
  Owner       = "scalar"
}
```

Note that the following tag keys are reserved by the tool and could be ignored even if you set them in `custom_tags`.

* `Name`
* `Terraform`
* `Network`
* `Role`
* `Trigger`
* `Image`
* `Tag`
