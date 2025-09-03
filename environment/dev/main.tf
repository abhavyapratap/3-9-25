module "rg" {
  source   = "../../modules/azurerm_resource_group"
  rg_name  = "rg-dev-venom"
  location = "centralindia"
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_vnet"
  vnet_name           = "V-Net"
  location            = "centralindia"
  resource_group_name = "rg-dev-venom"
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  subnet_name          = "venom-subnet"
  virtual_network_name = "V-Net"
  resource_group_name  = "rg-dev-venom"
  address_prefixes     = ["10.0.0.0/24"]
}

module "subnetforbastion" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  subnet_name          = "AzureBastionSubnet"
  virtual_network_name = "V-Net"
  resource_group_name  = "rg-dev-venom"
  address_prefixes     = ["10.0.1.0/26"]
}

module "nic" {
  depends_on           = [module.subnet]
  source               = "../../modules/azurerm_nic"
  nic_name             = "venom-nic"
  location             = "centralindia"
  resource_group_name  = "rg-dev-venom"
  subnet_name          = "venom-subnet"
  virtual_network_name = "V-Net"
}

module "pip" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_pip"
  pip_name            = "venom-pip"
  location            = "centralindia"
  resource_group_name = "rg-dev-venom"
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "nsg" {
  depends_on              = [module.rg]
  source                  = "../../modules/azurerm_nsg"
  nsg_name                = "venom-nsg"
  location                = "centralindia"
  resource_group_name     = "rg-dev-venom"
  destination_port_ranges = ["22", "80"]
}

module "vm" {
  depends_on          = [module.nic]
  source              = "../../modules/azurerm_vm"
  vm_name             = "Venom-VM"
  resource_group_name = "rg-dev-venom"
  location            = "centralindia"
  keyvault_name       = ""
  username_secret_key = ""
  pwd_secret_key      = ""
  nic_name            = "venom-nic"
  key_vault_rg        = ""
}

module "bastion" {
  depends_on           = [module.vnet, module.subnetforbastion, module.pip]
  source               = "../../modules/azurerm_bastion_host"
  bastion_name         = "bastion"
  location             = "centralindia"
  resource_group_name  = "rg-dev-venom"
  subnet_name          = "AzureBastionSubnet"
  virtual_network_name = "V-Net"
  pip_name             = "venom-pip"
}
