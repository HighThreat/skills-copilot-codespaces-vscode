output "resource_group_name" {
  value       = azurerm_resource_group.lab02.name
  description = "El nombre del Resource Group creado en Azure."
}

output "vnet_id" {
  value       = azurerm_virtual_network.lab02.id
  description = "El ID único de la Virtual Network (VNET)."
}

output "subnet_ids" {
  value       = azurerm_subnet.subnets[*].id
  description = "La lista de IDs de las subnets creadas."
}
