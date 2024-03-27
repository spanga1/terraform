/* output "availability_set_name" {
  value = {
    for k, availability_set in azurerm_availability_set.infinite-availability-set : k => availability_set.name
  }
}

output "availability_set_id" {
  value = {
    for k, availability_set in azurerm_availability_set.infinite-availability-set : k => availability_set.id
  }
}
 */
/* output "managed_os_disk_id" {
  #value = module.infinite_cloned_windows_vm.disk_id
  value = {
    for k, v in module.infinite_intermediate_vm: k => v.disk_id
  }
  
} */