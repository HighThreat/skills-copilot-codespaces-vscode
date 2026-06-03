output "resource_group_name" {
  value       = azurerm_resource_group.lab01.name
  description = "El nombre del Resource Group creado en Azure."
}

output "storage_account_name" {
  value       = azurerm_storage_account.lab01.name
  description = "El nombre de la Storage Account creada (única a nivel global)."
}

output "storage_container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "El nombre del Blob Container creado."
}

output "storage_account_id" {
  value       = azurerm_storage_account.lab01.id
  description = "El ID único del recurso Storage Account en Azure."
}
