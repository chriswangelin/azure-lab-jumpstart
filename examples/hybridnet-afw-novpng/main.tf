terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider azurerm {
  features { }
  skip_provider_registration = true
}

# module onprem {
#   source = "../../modules/hybridnet/onprem"

#   winra_vm_admin_password = var.winra_vm_admin_password
# }

module hub {
  source = "../../modules/hybridnet/hub"

  # Set enable_privatelink_xxx_pdnsz variables to true as needed to enable private DNS zones
  enable_privatelink_blob_core_windows_net_pdnsz = true
  enable_privatelink_vaultcore_azure_net_pdnsz   = true
  enable_privatelink_database_windows_net_pdnsz  = true

  ### Uncomment to add VPN gateway for onprem connectivity via S2S VPN
  # vpng_enable                   = true
  # vpng_connection_onprem_enable = true
  # vpng_shared_key               = var.vpng_shared_key
  # lgw_gateway_address           = module.onprem.winra_vm_public_ip_address
  # lgw_address_space             = module.onprem.vnet_address_space

  ### Uncomment to enable Azure firewall
  afw_enable = true
  #depends_on = [
  #  module.onprem
  #]
}

#  module s2svpn_onprem_to_hub {
#    source = "../../modules/hybridnet/s2svpn-winras-vpng"

#    vpng_public_ip_address = module.hub.vpng_public_ip_address
#    vpng_shared_key        = var.vpng_shared_key
#    winra_vm_id            = module.onprem.winra_vm_id

#    depends_on = [
#      module.hub
#    ]
#  }

 module lz1 {
   source = "../../modules/hybridnet/landing-zone"

   vnet_spoke_number                = 1
   hub_vnet_id                      = module.hub.vnet_id
   vnet_peering_use_remote_gateways = false
   depends_on = [
     module.hub
   ]
 }

 module lz2 {
   source = "../../modules/hybridnet/landing-zone"

   vnet_spoke_number                = 2
   hub_vnet_id                      = module.hub.vnet_id
   vnet_peering_use_remote_gateways = false
   depends_on = [
     module.hub
   ]
 }