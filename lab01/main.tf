# 1. Crear el Resource Group
resource "azurerm_resource_group" "lab01" {
  name     = "rg-lab01-${var.alumno_iniciales}"
  location = var.location
}

# 2. Crear la Storage Account
# Las Storage Accounts en Azure deben ser únicas a nivel global, 
# tener entre 3 y 24 caracteres, y contener solo letras minúsculas y números.
resource "azurerm_storage_account" "lab01" {
  name                     = lower("stalab01${var.alumno_iniciales}")
  resource_group_name      = azurerm_resource_group.lab01.name
  location                 = azurerm_resource_group.lab01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Lab01"
    Owner       = var.alumno_iniciales
  }
}

# 3. Crear el Blob Container para almacenar estados u otros objetos
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.lab01.name
  container_access_type = "private"
}
