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

variable "proximity_placement_group_id" {
  description = "Proximity placement group ID to which the VM is assigned"
  type        = string
}

variable "availability_set_id" {
  description = "Availability set ID to which the VM is assigned"
  type = string
}

variable "subnet_id" {
  description = "Subnet resource ID where Load balancer is created"
  type        = string
}

variable "data_disks" {
  type = map(object({
    data_disk_name                 = string
    data_disk_storage_account_type = string
    data_disk_size_gb              = number
    data_disk_lun_number           = string
    data_disk_caching              = string
    data_disk_create_option        = string
    data_disk_source_uri           = string
    max_shares                     = number
  }))
}




variable "cluster_vms" {
  type = map(object({

    location = string
    zone     = string
    nic_name = string

    enable_accelerated_networking  = bool
    resource_group_name            = string
    private_ip_address_allocation  = string
    availability_set_name          = string
    private_ip_address             = string
    additional_private_ip_addresses =  list(string)
    subnet_id                      = string
    network_security_group_id      = string

    computer_name = string
    size          = string

    patch_mode                   = string
    enable_automatic_updates     = bool
    admin_username               = string
    admin_password               = string
    os_disk_storage_account_type = string
    os_disk_name                 = string
    os_disk_caching              = string
    os_disk_size_gb              = number

    source_image_reference_publisher = string
    source_image_reference_offer     = string
    source_image_reference_sku       = string
    source_image_reference_version   = string

    source_image_id = string

    tags                         = map(string)
    user_data                    = string
    timezone                     = string
    public_ip_name               = string
    public_ip_address_allocation = string
    boot_diagnostics_storage_uri =  string


    #initialize_disk_script = string


    data_disks = map(object({
      data_disk_name                 = string
      data_disk_storage_account_type = string
      data_disk_size_gb              = number
      data_disk_lun_number           = string
      data_disk_caching              = string
      data_disk_create_option        = string
      data_disk_source_uri           = string
      max_shares                     = number
    }))


  }))


}



/* variable "data_disk_attachments" {
  type = map(object({
    computer_name        = string
    data_disk_name       = string
    data_disk_lun_number = string
    data_disk_caching    = string
  }))
} */
/* 

variable "lb_zones" {
  description = "List of Availability Zones where Load Balancer IP should be located"
  type        = list(number)
}

variable "lb_name" {
  description = "Load balancer name"
  type        = string
}

variable "lb_private_ip_address" {
  description = "Load balancer IP address"
  type        = string
}

variable "lb_private_ip_address_allocation" {
  description = "Load balancer IP address allocation"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_ip_address" {
  type = string
}

variable "ad_domain_name" {
  type = string
}

variable "ad_username" {
  type = string
}

variable "ad_password" {
  type = string
}

variable "ad_hostname" {
  type = string
}
 */

