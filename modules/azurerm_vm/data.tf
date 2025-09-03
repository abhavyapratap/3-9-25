data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "username" {
  name         = var.username_secret_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "password" {
  name         = var.pwd_secret_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
}