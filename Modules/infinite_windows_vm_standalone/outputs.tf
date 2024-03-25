output "network_interface_id" {
  value       = azurerm_network_interface.infinite_nic.id
}

output "private_ip_address" {
  value       = azurerm_network_interface.infinite_nic.private_ip_address
}


output "public_ip_address_id" {
  value = (var.public_ip_name) == "" ? null : azurerm_public_ip.infinite_vm_public_ip[0].id
}

output "public_ip_address" {
  value = (var.public_ip_name) == "" ? null : azurerm_public_ip.infinite_vm_public_ip[0].ip_address
}

output "vm_id"{
  value = azurerm_windows_virtual_machine.infinite_windows_vm_standalone.id
}

