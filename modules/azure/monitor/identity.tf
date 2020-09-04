data "azurerm_subscription" "subscription" {}

data "azurerm_role_definition" "contributor" {
  name = "Storage Blob Data Contributor"
}

data "azurerm_storage_account" "monitor" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? 1 : 0

  resource_group_name = local.network_name
  name                = local.log_archive_storage.storage_account
}

resource "azurerm_role_assignment" "monitor" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? local.monitor.resource_count : 0

  scope              = data.azurerm_storage_account.monitor[0].id
  role_definition_id = "${data.azurerm_subscription.subscription.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = module.monitor_cluster.vm_identities[count.index][0]["principal_id"]
}
