resource "azurerm_lb" "ssxlb" {
  name                = "SSXOdooLB"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "ssxlb-feip"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
  tags = {
    environment = "SSXOdoo"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.ssxlb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "httpodoo" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.ssxlb.id
  name                = "SSXOdooProbeHttp"
  port                = 80
}

resource "azurerm_lb_probe" "httpsodoo" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.ssxlb.id
  name                = "SSXOdooProbeHttps"
  port                = 443
}

resource "azurerm_lb_rule" "lbnathttp" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.ssxlb.id
  name                           = "SSXOdooNatHttpRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.ssxlb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.httpodoo.id
}

resource "azurerm_lb_rule" "lbnathttps" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.ssxlb.id
  name                           = "SSXOdooNatHttpsRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.ssxlb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.httpsodoo.id
}