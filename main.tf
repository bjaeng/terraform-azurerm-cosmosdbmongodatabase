locals {
  name = var.override_name == null ? "${var.system_name}-${lower(var.environment)}-mongodb" : var.override_name

  cosmosdb_mongo_database = concat(azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database[*], [null])[0]
}

resource "azurerm_cosmosdb_mongo_database" "cosmosdb_mongo_database" {
  name                = local.name
  resource_group_name = var.resource_group.name

  account_name = var.cosmosdb_account.name

  throughput = var.enable_autoscale_settings == false ? var.throughput : null

  dynamic "autoscale_settings" {
    for_each = var.enable_autoscale_settings == true ? [1] : []
    content {
      max_throughput = var.autoscale_settings_max_throughput
    }
  }
}
