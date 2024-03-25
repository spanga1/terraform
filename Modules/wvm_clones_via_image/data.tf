#import gallery details
data "azurerm_shared_image_gallery" "target_image_gallery" {
     name                = var.gallery_name
     resource_group_name = var.gallery_resource_group_name
  
}