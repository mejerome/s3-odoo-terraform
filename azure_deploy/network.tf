resource "azurerm_virtual_network" "ssx_vnet" {
  name                = var.vnet_name
  address_space       = [var.addressprefix]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "compute" {
  name                 = "computeSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.ssx_vnet.name
  address_prefixes     = [var.computesubnetprefix]
}

resource "azurerm_subnet" "database" {
  name                 = "databaseSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.ssx_vnet.name
  address_prefixes     = [var.databasesubnetprefix]
}

resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

resource "azurerm_public_ip" "lbpip" {
  name                = "SsxPublicIP"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = random_string.fqdn.result
}

resource "azurerm_network_interface" "ssxodoocompute" {
  name                = "ssxodoo-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ssxodoo-ip"
    subnet_id                     = azurerm_subnet.compute.id
    private_ip_address_allocation = "Dynamic"
  }
}
