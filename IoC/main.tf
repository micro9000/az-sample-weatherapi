terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "tf_rg_blobstore"
        storage_account_name = "newtfstorageaccount"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "Southeast Asia"
}

resource "azurerm_container_group" "tfcg_test" {
    name                    = "weatherapi"
    location                = azurerm_resource_group.tf_test.location
    resource_group_name     = azurerm_resource_group.tf_test.name
    
    ip_address_type         = "public"
    dns_name_label          = "raniel12345DNSTest"
    os_type                 = "Linux"

    container {
        name                = "weatherapi"
        image               = "raniel12345/weatherapi:${var.imagebuild}"
        cpu                 = "1"
        memory              = "1"

        ports {
            port            = 80
            protocol        = "TCP"
        }
    }    
}