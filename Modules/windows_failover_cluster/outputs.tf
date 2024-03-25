output "data_disks_id"{
  value = {
    for k, disk in azurerm_managed_disk.infinite_disk: k => disk.id
  }
}

output "cluster_vm_ids" {
  value = {
    for k, cluster_vm in module.infinite_windows_vm_standalone: k => cluster_vm.vm_id
  }
}