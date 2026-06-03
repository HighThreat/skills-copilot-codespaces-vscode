# 1. Crear el Resource Group usando lower() y join()
resource "azurerm_resource_group" "lab02" {
  name     = lower(join("-", [var.resource_group_name, var.env_prefix]))
  location = var.region
}

# 2. Crear la Virtual Network usando lower() y join()
resource "azurerm_virtual_network" "lab02" {
  name                = lower(join("-", ["vnet", var.env_prefix, "lab02"]))
  location            = azurerm_resource_group.lab02.location
  resource_group_name = azurerm_resource_group.lab02.name
  address_space       = var.vnet_address_space
}

# 3. Crear las Subnets dinámicamente usando count, length() y lower()
resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = lower(var.subnet_names[count.index])
  resource_group_name  = azurerm_resource_group.lab02.name
  virtual_network_name = azurerm_virtual_network.lab02.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.lab02.address_space[0], 8, count.index)]
}

# 4. Crear el Network Security Group usando lower(), join() y length() para tags
resource "azurerm_network_security_group" "lab02" {
  name                = lower(join("-", ["nsg", var.env_prefix, "lab02"]))
  location            = azurerm_resource_group.lab02.location
  resource_group_name = azurerm_resource_group.lab02.name

  tags = {
    Environment = var.env_prefix
    SubnetCount = length(var.subnet_names)
    SubnetList  = join(", ", var.subnet_names)
  }
}
