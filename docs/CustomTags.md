# Tagging Resources

scalar-terraform provides a feature to add arbitrary tags to resources. The feature may be useful to group resources so that you can do some operations for a particular group such as calculating cost.

At present, the feature is only supported in AWS.

## How to add tags

You can use `custom_tags` variable defined in `network` module to add tags to resources.
The tags will be applied to all the resources created by other modules that reference `network` module's output.

```
custom_tags = {
  Environment = "production"
  Owner       = "scalar"
}
```

Note that the following tag keys are reserved by the tool so they are ignored if they are set in `custom_tags`.

* `Name`
* `Terraform`
* `Network`
* `Role`
* `Trigger`
* `Image`
* `Tag`
