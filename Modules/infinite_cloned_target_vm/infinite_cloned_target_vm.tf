/* #allocating public IP
resource "azurerm_public_ip" "infinite_vm_public_ip" {
  count               = var.public_ip_name == "" ? 0 : 1
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_address_allocation
}

#creating NIC
resource "azurerm_network_interface" "infinite_nic" {
  name     = var.nic_name
  location = var.location
  #zone                          = var.zone
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking

  #allocating private IP
  ip_configuration {
    name                          = var.nic_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = (var.public_ip_name) == "" ? null : azurerm_public_ip.infinite_vm_public_ip[0].id
  }
}

resource "azurerm_network_interface_security_group_association" "infinte-nic-nsg-association" {
  count                     = var.network_security_group_id == null ? 0 : 1
  network_interface_id      = azurerm_network_interface.infinite_nic.id
  network_security_group_id = var.network_security_group_id

  depends_on = [
    azurerm_network_interface.infinite_nic
  ]
}




#creating VM
resource "azurerm_virtual_machine" "infinite_cloned_target_vm" {
  name                         = var.computer_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  vm_size                      = var.size
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id
  network_interface_ids        = [azurerm_network_interface.infinite_nic.id]
  
  storage_os_disk {
    name          = var.os_disk_name
    create_option = "FromImage"
    os_type       = var.os_type
    caching       = var.os_disk_caching
    disk_size_gb  = var.os_disk_size_gb

  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = "sysadmin"
    admin_password = "kE6gC3dW4qD1dM5i3"
  }

  storage_image_reference {
    id = var.gallery_image_id
  }


  tags = var.tags

  dynamic "os_profile_windows_config" {
    for_each = (var.os_type == "Windows") ? [1] : []
    content {
      #timezone = "Eastern Standard Time"
      timezone = var.timezone
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.boot_diagnostics_storage_uri
  }

  depends_on = [
    azurerm_network_interface.infinite_nic
  ]
}
 



resource "azurerm_managed_disk" "infinite_data_disk" {

  for_each             = var.data_disks
  name                 = each.value.data_disk_name
  location             = var.location
  zone                 = var.zone
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.data_disk_storage_account_type
  disk_size_gb         = each.value.data_disk_size_gb
  create_option        = each.value.data_disk_create_option

  source_resource_id = (each.value.data_disk_create_option) == "Empty" ? null : each.value.data_disk_source_uri
}

resource "azurerm_virtual_machine_data_disk_attachment" "infinite_data_disk_attachment" {

  for_each           = var.data_disks
  managed_disk_id    = azurerm_managed_disk.infinite_data_disk[each.key].id
  virtual_machine_id = azurerm_virtual_machine.infinite_cloned_target_vm.id
  lun                = each.value.data_disk_lun_number
  caching            = each.value.data_disk_caching

  depends_on = [
    azurerm_managed_disk.infinite_data_disk,
    azurerm_virtual_machine.infinite_cloned_target_vm
  ]
}


 */