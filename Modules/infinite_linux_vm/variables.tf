variable "nic_name" {
  description = "Name of the VM NIC"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region where resources are located"
  type        = string
}

variable "zone" {
  description = "Region where VM is located"
  type        = string
}

variable "enable_accelerated_networking" {
  description = "Enable accelerated networking feature for the VM NIC"
  type        = bool
}

variable "availability_set_id" {
  description = "Availability set ID to which the VM is assigned"
  type = string
} 

variable "proximity_placement_group_id" {
  description = "Proximity placement group ID to which the VM is assigned"
  type = string
}

variable "private_ip_address" {
  description = "Private IP allocated to VM"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "Type of Private IP allocation to VM"
  type        = string
}

variable "additional_private_ip_addresses" {
  description = "Additional Private IP allocated to VM"
  type        = list(string)
}

variable "network_security_group_id" {
  description = "List of NSGs to be associated with the VM"
  type        = string
}

variable "computer_name" {
  description = "Name of VM"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to which VM is associated"
  type = string
}

variable "size" {
  description = "Size of the VM to be created"
  type        = string
}

variable "patch_mode" {
  description = "OS Patch mode for the VM to be created"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM login"
  type        = string
}

variable "admin_password" {
  description = "Password for Admin account"
  type        = string
}

variable "disable_password_authentication" {
  description = "Enable or disable password login to VM"
  type        = bool
}

variable "admin_ssh_key_username" {
  description = "Username for SSH authentication"
  type        = string
} 

variable "public_key" {
  description = "Public key file path"
  type        = string
}

variable "license_type" {
  description = "Specifies the BYOL Type for this VM"
  type = string
}

variable "os_disk_storage_account_type" {
  description = "Storage type for the OS disk"
  type        = string
}

variable "os_disk_name" {
  description = "Name of Internal OS Disk"
  type        = string
}

variable "os_disk_caching" {
  description = "Type of Caching which should be used for the Internal OS Disk"
  type        = string
}

variable "os_disk_size_gb" {
  description = "Size of the Internal OS Disk"
  type        = number
}

variable "source_image_reference_publisher" {
   description = "Publisher of this VM image in Azure marketplace"
  type        = string
}

variable "source_image_reference_offer" {
  description = "Offer of the VM image"
  type        = string
}

variable "source_image_reference_sku" {
  description = "SKU version of the OS"
  type = any
}

variable "source_image_reference_version" {
  description = "OS Version of the VM image"
  type        = any
}



variable "data_disks" {
  type = map(object({
      data_disk_name                  = string
      data_disk_storage_account_type  = string
      data_disk_size_gb               = number
      data_disk_lun_number            = string
      data_disk_caching               = string
      data_disk_create_option = string
      data_disk_source_uri =  string
    }))

}

variable "tags" {
  type = map
}

variable "user_data" {
  description = "Startup script for VM"
  type        = string
}

variable "timezone" {
  description = "Timezone to be set for VM"
  type        = string
}

variable "public_ip_name"{
  description = "Public IP Name allocated to VM"
  type        = string
}

variable "public_ip_address_allocation" {
  description = "Type of Public IP allocation to VM"
  type        = string
}

variable "source_image_id" {
  type        = string
}

variable "boot_diagnostics_storage_uri" {
  type = string
}






/*

variable "gallery_image_name" {
  description = "gallery_image_name of VM"
  type        = string
}

variable "azure_compute_gallery_name" {
  description = "Azure compute gallery name"
  type        = string
}


 variable "data_disk_name" {
  description = "Name of data disk to be attached to VM"
  type        = string
}

variable "data_disk_storage_account_type" {
  description = "Storage type for the data disk"
  type        = string
}

variable "data_disk_create_option" {
  #description check
  description = "Create empty disk or attach existing disk"
  type        = string
}

variable "data_disk_size_gb" {
  description = "Data disk size in GB"
  type        = number
}

variable "data_disk_lun_number" {
  description = "LUN number to be assigned to data disk"
  type        = string
}

variable "data_disk_caching" {
  description = "Type of data disk caching"
  type        = string
} */

/*variable "vnet_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "address_space" {
  description = "Address space of the Virtual Network created"
  type        = any
}

variable "subnet_prefixes" {
  description = "Prefix of the Subnetwork created"
  type        = any
}

variable "subnet_names" {
  description = "Name of the Subnetwork created"
  type        = string
}
variable "admin_password" {
  description = "Password for Admin account"
  type        = string
}
*/

