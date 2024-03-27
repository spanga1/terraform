#allocating public IP
resource "azurerm_public_ip" "infinite_vm_public_ip" {
  count               = var.public_ip_name == "" ? 0 : 1
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_address_allocation
}

#creating NIC
resource "azurerm_network_interface" "infinite_nic" {
  name                          = var.nic_name
  location                      = var.location
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
  count               = var.network_security_group_id == null ? 0 : 1
  network_interface_id      = azurerm_network_interface.infinite_nic.id
  network_security_group_id = var.network_security_group_id

  depends_on = [
    azurerm_network_interface.infinite_nic
  ]
}

resource "azurerm_snapshot" "infinite_os_disk_snapshot" {
  name                = "${var.computer_name}-snapshot"
  location            = var.location
  resource_group_name = var.resource_group_name
  create_option       = "Copy"             
  source_uri          = var.os_disk_source_uri
  tags = {
    "purpose" = "cloning"
    "creation_date" = formatdate("DD-MMM-YYYY", timestamp())
  }
}

resource "azurerm_managed_disk" "infinite_os_managed_disk" {
  name                 = var.os_disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.os_disk_storage_account_type
  create_option        = "Copy"
  source_resource_id   = azurerm_snapshot.infinite_os_disk_snapshot.id
}


#creating VM

resource "azurerm_virtual_machine" "infinite_cloned_vm" {
  name                         = var.computer_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  vm_size                      = var.size
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id
  network_interface_ids           = [azurerm_network_interface.infinite_nic.id]
  

  storage_os_disk {
    name                 = var.os_disk_name
    create_option        = "Attach"
    os_type              = var.os_type
    caching              = var.os_disk_caching
    disk_size_gb         = var.os_disk_size_gb
    managed_disk_id      = azurerm_managed_disk.infinite_os_managed_disk.id
    #managed_disk_type    = var.os_disk_storage_account_type
  }


  tags      = var.tags

  dynamic "os_profile_windows_config" {
    for_each = (var.os_type == "Windows") ? [1] : []
    content{
      #timezone = "Eastern Standard Time"
      timezone = var.timezone
    }
  }
  
  boot_diagnostics {
    enabled = true
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
  virtual_machine_id = azurerm_virtual_machine.infinite_cloned_vm.id
  lun                = each.value.data_disk_lun_number
  caching            = each.value.data_disk_caching

  depends_on = [
    azurerm_managed_disk.infinite_data_disk,
    azurerm_virtual_machine.infinite_cloned_vm
  ]
}


resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "powershell.exe Start-Sleep -Seconds 180"
  }

  depends_on = [
    azurerm_public_ip.infinite_vm_public_ip,
    azurerm_network_interface.infinite_nic,
    azurerm_network_interface_security_group_association.infinte-nic-nsg-association,
    azurerm_snapshot.infinite_os_disk_snapshot,
    azurerm_managed_disk.infinite_os_managed_disk,
    azurerm_virtual_machine.infinite_cloned_vm,
    azurerm_managed_disk.infinite_data_disk,
    azurerm_virtual_machine_data_disk_attachment.infinite_data_disk_attachment
  ]
}



resource "azurerm_virtual_machine_extension" "infinite_extension_windows" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.infinite_cloned_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe Rename-Computer -NewName ${azurerm_virtual_machine.infinite_cloned_vm.name} -Restart"
    }
SETTINGS

  depends_on = [
    null_resource.delay
  ]

}


resource "azurerm_virtual_machine_extension" "infinite_extension_linux_hostname" {
  count               = (var.os_type == "Linux" && var.timezone == "") ? 1 : 0
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.infinite_cloned_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo hostnamectl set-hostname ${azurerm_virtual_machine.infinite_cloned_vm.name} ; sudo sysctl kernel.hostname=${azurerm_virtual_machine.infinite_cloned_vm.name}"

    }
SETTINGS

depends_on = [
    null_resource.delay
  ]
}

resource "azurerm_virtual_machine_extension" "infinite_extension_linux_hostname_timezone" {
  count               = (var.os_type == "Linux" && var.timezone != "") ? 1 : 0
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.infinite_cloned_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo hostnamectl set-hostname ${azurerm_virtual_machine.infinite_cloned_vm.name} ; sudo sysctl kernel.hostname=${azurerm_virtual_machine.infinite_cloned_vm.name}; sudo timedatectl set-timezone ${var.timezone}"

    }
SETTINGS

depends_on = [
    null_resource.delay
  ]
}

resource "null_resource" "cooloff" {
  provisioner "local-exec" {
    command = "powershell.exe Start-Sleep -Seconds 180"
  }

  depends_on = [
    azurerm_virtual_machine_extension.infinite_extension_windows, azurerm_virtual_machine_extension.infinite_extension_linux
  ]
}















/* resource "azurerm_snapshot" "infinite_data_disk_snapshot" {

  for_each            = var.data_disk_snapshots
  name                = each.value.data_disk_snapshot_name
  location            = var.location
  resource_group_name = var.resource_group_name
  create_option       = "Copy"
  source_uri          = each.value.data_disk_source_uri
  tags = {
    "purpose" = "cloning"
    "creation_date" = formatdate("DD-MMM-YYYY", timestamp())
  }
} 

resource "null_resource" "rename_host" {

  provisioner "local-exec" {
    command = <<EOT
       az vm run-command invoke \
                    --resource-group ${var.resource_group_name}  \
                    --name ${var.computer_name} \
                    --command-id RunPowerShellScript \
                    --scripts "Rename-Computer -NewName ${var.computer_name} -Restart"
  EOT
  }
  depends_on = [
    null_resource.delay
  ]
}*/


 /*  os_profile {
    computer_name = var.computer_name
    admin_username = ""
    admin_password = ""
    custom_data = "Powershell -command Rename-Computer -NewName 'newname' -Restart"
  }

  dynamic "os_profile_windows_config" {
    for_each = (var.os_type == "Windows") ? [1] : []
    content{}
  }
  
  dynamic "os_profile_linux_config" {
    for_each = (var.os_type == "Linux") ? [1] : []
    content{
      disable_password_authentication = false
    }
  }
 */
