 output "disk_id" {
  value = module.infinite_cloned_vm.infinite_os_managed_disk_id
 /*  value = {
    for k, v in module.infinite_cloned_vm : k => v.infinite_os_managed_disk_id
  } */
   
 }

 output "gallery_image_id" {
   value = azurerm_shared_image_version.inifinite_shared_image_version.id
 }