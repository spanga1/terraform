resource "azurerm_managed_disk" "infinite_disk" {

  for_each             = var.data_disks
  name                 = each.value.data_disk_name
  location             = var.location
  zone                 = var.zone
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.data_disk_storage_account_type
  create_option        = each.value.data_disk_create_option
  disk_size_gb         = each.value.data_disk_size_gb
  max_shares           = each.value.max_shares
  source_resource_id   = (each.value.data_disk_create_option) == "Empty" ? null : each.value.data_disk_source_uri
}


module "infinite_windows_vm_standalone" {
  source = "../infinite_windows_vm_standalone/"
  /*   depends_on = [
    azurerm_resource_group.infinite-rg,
    azurerm_availability_set.infinite-availability-set,
    azurerm_proximity_placement_group.infinite-ppg
  ] */

  for_each = var.cluster_vms

  location                      = each.value.location
  zone                          = each.value.zone
  nic_name                      = each.value.nic_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  subnet_id                     = each.value.subnet_id
  #subnet_id                     = module.vnet[each.value.vnet_name].subnet_ids[each.value.subnet_names]


  proximity_placement_group_id = var.proximity_placement_group_id
  availability_set_id       = var.availability_set_id
  network_security_group_id = each.value.network_security_group_id

  resource_group_name            = each.value.resource_group_name
  private_ip_address_allocation  = each.value.private_ip_address_allocation
  private_ip_address             = each.value.private_ip_address
  additional_private_ip_addresses = each.value.additional_private_ip_addresses

  computer_name = each.value.computer_name
  size          = each.value.size

  patch_mode               = each.value.patch_mode
  enable_automatic_updates = each.value.enable_automatic_updates
  admin_username           = each.value.admin_username
  admin_password           = each.value.admin_password

  os_disk_storage_account_type = each.value.os_disk_storage_account_type
  os_disk_name                 = each.value.os_disk_name
  os_disk_caching              = each.value.os_disk_caching
  os_disk_size_gb              = each.value.os_disk_size_gb

  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version


  source_image_id = each.value.source_image_id

  data_disks = each.value.data_disks

  tags                         = each.value.tags
  user_data                    = each.value.user_data
  timezone                     = each.value.timezone
  public_ip_address_allocation = each.value.public_ip_address_allocation
  public_ip_name               = each.value.public_ip_name
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri


}





































#creating LB components

/*resource "azurerm_lb" "infinite_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                          = "${var.lb_name}_frontend_ip_configuration"
    zones                         = var.lb_zones
    subnet_id                     = var.subnet_id
    private_ip_address            = var.lb_private_ip_address
    private_ip_address_allocation = var.lb_private_ip_address_allocation
  }
}

resource "azurerm_lb_backend_address_pool" "infinite_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.infinite_lb.id
  name            = "${var.lb_name}_backend_pool"

  depends_on = [
    azurerm_lb.infinite_lb
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "infinite_nic_lb_backend_pool_association" {
  for_each                = var.cluster_vms
  network_interface_id    = module.infinite_windows_vm_standalone[each.value.computer_name].network_interface_id
  ip_configuration_name   = each.value.nic_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.infinite_lb_backend_pool.id

  depends_on = [
    azurerm_lb_backend_address_pool.infinite_lb_backend_pool,
    module.infinite_windows_vm_standalone
  ]
}

resource "azurerm_lb_probe" "infinite_lb_probe" {
  loadbalancer_id = azurerm_lb.infinite_lb.id
  name            = "${var.lb_name}_probe"
  port            = 59999

  depends_on = [
    azurerm_lb.infinite_lb
  ]
}

resource "azurerm_lb_rule" "infinite_lb_rule" {
  loadbalancer_id                = azurerm_lb.infinite_lb.id
  name                           = "${var.lb_name}_rule"
  protocol                       = "Tcp"
  frontend_port                  = 1433
  backend_port                   = 1433
  frontend_ip_configuration_name = "${var.lb_name}_frontend_ip_configuration"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.infinite_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.infinite_lb_probe.id
  enable_floating_ip             = true

  depends_on = [
    azurerm_lb.infinite_lb,
    azurerm_lb_backend_address_pool.infinite_lb_backend_pool,
    azurerm_lb_probe.infinite_lb_probe
  ]
}

 resource "azurerm_virtual_machine_data_disk_attachment" "infinite_disk_attachment" {

  for_each           = var.data_disk_attachments
  managed_disk_id    = azurerm_managed_disk.infinite_disk[each.value.data_disk_name].id
  virtual_machine_id = module.infinite_windows_vm_standalone[each.value.computer_name].vm_id
  lun                = each.value.data_disk_lun_number
  caching            = each.value.data_disk_caching

  depends_on = [
    azurerm_managed_disk.infinite_disk,
    module.infinite_windows_vm_standalone
  ]
} */




















/* resource "azurerm_virtual_machine_extension" "initialize_disk" {
  for_each = var.cluster_vms
  name                = format("%s%s","initialize_disk",each.value.computer_name)
  virtual_machine_id   = module.infinite_windows_vm_standalone[each.value.computer_name].vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version   = "1.10"

  settings = <<SETTINGS
    {
       "commandToExecute": "powershell.exe -command \"${each.value.initialize_disk_script}\""
    }
SETTINGS

  depends_on = [
    module.infinite_windows_vm_standalone
  ]
} */


