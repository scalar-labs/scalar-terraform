data "azurerm_subscription" "subscription" {}

data "azurerm_role_definition" "contributor" {
  name = "Storage Blob Data Contributor"
}

data "azurerm_storage_account" "cassy-storage-account" {
  # If the resource_count of Cassy > 0, this resource makes local.cassy.storage_account_name required and ensures it is accessible.
  count = local.cassy.resource_count > 0 ? 1 : 0

  resource_group_name = local.network_name
  name                = local.cassy.storage_account_name
}

resource "azurerm_role_assignment" "cassy" {
  count = local.cassy.resource_count

  scope              = data.azurerm_storage_account.cassy-storage-account[0].id
  role_definition_id = "${data.azurerm_subscription.subscription.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = module.cassy_cluster.vm_identities[count.index][0]["principal_id"]
}

resource "azurerm_role_assignment" "cassandra" {
  count = length(data.azurerm_storage_account.cassy-storage-account) > 0 ? local.cassandra.resource_count : 0

  scope              = data.azurerm_storage_account.cassy-storage-account[0].id
  role_definition_id = "${data.azurerm_subscription.subscription.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = module.cassandra_cluster.vm_identities[count.index][0]["principal_id"]
}
