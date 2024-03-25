terraform {
  required_version = "1.3.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.17"
    }
  }

}

provider "azurerm" {
  features {
    virtual_machine {
      graceful_shutdown = true
      delete_os_disk_on_deletion = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
