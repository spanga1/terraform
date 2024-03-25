variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region where resources are located"
  type        = string
}

variable "source_os_disk_uri" {
  description = "Resource ID of Original VM OS disk"
  type        = string
}

variable "computer_name" {
  description = "Name of VM"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to which VM is associated"
  type        = string
}

variable "availability_set_id" {
  description = "Availability set ID to which the VM is assigned"
  type        = string
}

variable "proximity_placement_group_id" {
  description = "Proximity placement group ID to which the VM is assigned"
  type        = string
}

variable "size" {
  description = "Size of the VM to be created"
  type        = string
}

variable "source_os_disk_size_gb" {
  description = "Size of the Internal OS Disk"
  type        = number
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage account for Boot diagnostics"
  type        = string
}

variable "gallery_name" {
  type = string
  description = "name of the gallery which contains the image ."
  
}
variable "gallery_resource_group_name" {
  type = string
  description = "resoruce group name of the image gallery which is beinf used "
  
}
variable "gallery_location" {
  type = string
  description = "location in which the image gallery is located "
  
}
variable "target_vms" {
  type = map(object({
      public_ip_name                  = string
      public_ip_address_allocation    = string
      nic_name                        = string
      location                        = string
      zone                            = string
      resource_group_name             = string
      enable_accelerated_networking   = bool
      subnet_id                       = string
      boot_diagnostics_storage_uri    = string
      network_security_group_id       = string
      timezone                        = string
      disable_password_authentication = string
      patch_mode                      = string
      private_ip_address_allocation   = string
      private_ip_address              = string
      additional_private_ip_addresses = list(string)
      enable_automatic_updates        = bool
      admin_username                  = string
      admin_password                  = string
      computer_name                   = string
      size                            = string
      os_disk_name                    = string
      os_disk_size_gb                 = string
      os_type                         = string
      os_disk_caching                 = string
      os_disk_storage_account_type    = string
      proximity_placement_group_name  = string
      proximity_placement_group_id    = string
      availability_set_name           = string
      availability_set_id             = string
      tags                            = map(string)
      data_disks = map(object({
        data_disk_name                 = string
        data_disk_storage_account_type = string
        data_disk_size_gb              = number
        data_disk_lun_number           = string
        data_disk_caching              = string
        data_disk_create_option        = string
        data_disk_source_uri           = string

      }))
      source_image_reference_publisher = string
      source_image_reference_offer     = string
      source_image_reference_sku       = string
      source_image_reference_version   = string
      user_data                        = string
      boot_diagnostics_storage_uri = string
    }))
  
}


