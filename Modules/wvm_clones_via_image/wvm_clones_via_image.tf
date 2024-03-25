 module "infinite_cloned_vm" {
  source = "../infinite_cloned_vm"

  location                      = var.location
  zone                          = null
  nic_name                      = "${var.computer_name}-inter-nic"
  enable_accelerated_networking = false
  #subnet_id                     = module.vnet[var.vnet_name].subnet_ids[var.subnet_names]
  subnet_id                     = var.subnet_id
  proximity_placement_group_id  = null
  network_security_group_id     = null
  availability_set_id           = null
  resource_group_name           = var.resource_group_name
  private_ip_address_allocation = "Dynamic"
  private_ip_address            = ""

  computer_name = var.computer_name
  size          = var.size
  license_type = "Windows_Server"

  os_disk_name                 = "${var.computer_name}-inter"
  os_type                      = "Windows"
  os_disk_caching              = "ReadWrite"
  os_disk_size_gb              = var.source_os_disk_size_gb
  os_disk_storage_account_type = "Standard_LRS"

  tags = {
    "purpose" = "cloning"
    "creation_date" = formatdate("DD-MMM-YYYY", timestamp())
  }
  
  boot_diagnostics_storage_uri = var.boot_diagnostics_storage_uri
  timezone                     = ""

  os_disk_snapshot_name = ""
  source_os_disk_uri    = var.source_os_disk_uri


  data_disks = {}

  public_ip_address_allocation = "Dynamic"
  public_ip_name               = ""


}


resource "azurerm_image" "infinite_image" {
  name                = "${var.computer_name}-image"
  location            = var.location
  resource_group_name = var.resource_group_name
  hyper_v_generation = "V2"
  os_disk {
    os_type  = "Windows"
    os_state = "Generalized"
    managed_disk_id = module.infinite_cloned_vm.infinite_os_managed_disk_id
    size_gb         = 128
  }
  depends_on = [
    module.infinite_cloned_vm
  ]
}


resource "azurerm_shared_image" "infinite_shared_image" {
  name                = "${var.computer_name}-shared_image"
  gallery_name        = data.azurerm_shared_image_gallery.target_image_gallery.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "${var.computer_name}Publisher"
    offer     = "${var.computer_name}Offer"
    sku       = "${var.computer_name}Sku"
  }

  tags = {
    "purpose" = "cloning"
    "creation_date" = formatdate("DD-MMM-YYYY", timestamp())
  }

  depends_on = [
    data.azurerm_shared_image_gallery.target_image_gallery,
    azurerm_image.infinite_image
  ]
}

resource "azurerm_shared_image_version" "inifinite_shared_image_version" {
  #for_each = var.infinite_cloned_vms
  name                = "0.0.1"
  gallery_name        = data.azurerm_shared_image_gallery.target_image_gallery.name
  image_name          = azurerm_shared_image.infinite_shared_image.name
  resource_group_name = var.resource_group_name
  location            = var.location
  managed_image_id    = azurerm_image.infinite_image.id

  target_region {
    name                   = azurerm_shared_image.infinite_shared_image.location
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }

  tags = {
    "purpose" = "cloning"
    "creation_date" = formatdate("DD-MMM-YYYY", timestamp())
  }
  
  depends_on = [
    azurerm_shared_image.infinite_shared_image,
    data.azurerm_shared_image_gallery.target_image_gallery,
    azurerm_image.infinite_image
  ]
}
resource "null_resource" "delay" {
  provisioner "local-exec" {
   # command = "powershell.exe Start-Sleep -Seconds 180"
    command = "sleep 180"
  }
  depends_on = [
    azurerm_image.infinite_image,
    azurerm_shared_image_version.inifinite_shared_image_version
  ]
}
 

module "infinite_windows_vm_standalone" {
  source = "../infinite_windows_vm_standalone"

  depends_on = [
    azurerm_shared_image_version.inifinite_shared_image_version,
  ]

  for_each = var.target_vms

  location                      = each.value.location
  zone                          = each.value.zone
  nic_name                      = each.value.nic_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  #subnet_id                     = module.vnet[each.value.vnet_name].subnet_ids[each.value.subnet_names]
  subnet_id                    = each.value.subnet_id
  proximity_placement_group_id  = var.proximity_placement_group_id

  availability_set_id           = var.availability_set_id
  network_security_group_id = each.value.network_security_group_id

  resource_group_name             = each.value.resource_group_name
  private_ip_address_allocation   = each.value.private_ip_address_allocation
  private_ip_address              = each.value.private_ip_address
  additional_private_ip_addresses = each.value.additional_private_ip_addresses
  computer_name                   = each.value.computer_name
  size                            = each.value.size

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

  source_image_id = azurerm_shared_image.infinite_shared_image.id

  data_disks = each.value.data_disks

  tags                         = each.value.tags
  user_data                    = each.value.user_data
  timezone                     = each.value.timezone
  public_ip_address_allocation = each.value.public_ip_address_allocation
  public_ip_name               = each.value.public_ip_name
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri


} 


/* 
module "infinite_cloned_target_vm" {
  source                       = "../infinite_cloned_target_vm"
  for_each                     = var.target_vms
  public_ip_name               = each.value.public_ip_name
  public_ip_address_allocation = each.value.public_ip_address_allocation
  resource_group_name          = each.value.resource_group_name

  enable_accelerated_networking = each.value.enable_accelerated_networking
  location                      = each.value.location
  nic_name                      = each.value.nic_name
  subnet_id                     = each.value.subnet_id

  private_ip_address_allocation = each.value.private_ip_address_allocation
  private_ip_address            = each.value.private_ip_address
  network_security_group_id     = each.value.network_security_group_id
  computer_name                 = each.value.computer_name
  size                          = each.value.size
  os_disk_storage_account_type  = each.value.os_disk_storage_account_type

  availability_set_id          = each.value.availability_set_id
  proximity_placement_group_id = each.value.proximity_placement_group_id

  os_disk_name     = each.value.os_disk_name
  os_type          = each.value.os_type
  os_disk_caching  = each.value.os_disk_caching
  os_disk_size_gb  = each.value.os_disk_size_gb
  gallery_image_id = azurerm_shared_image.infinite_shared_image.id

  tags                         = each.value.tags
  timezone                     = each.value.timezone
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri
  data_disks                   = each.value.data_disks
  zone                         = each.value.zone
}

 */