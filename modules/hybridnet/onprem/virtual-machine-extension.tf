# This vm extension must execute before setting the DNS servers on the onprem vnet.
resource azurerm_virtual_machine_extension dns_vm_001_config_unbound_dns_customscript_vmext {
  name                 = "dns_vm_001_config_unbound_dns_customscript"
  virtual_machine_id   = module.dns_vm_001.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
  {
     "fileUris": ["https://raw.githubusercontent.com/chriswangelin/azure-terraform-modules/develop/modules/hybridnet/onprem/scripts/config-unbound-dns-onprem-rhel-centos.sh"],
     "commandToExecute": "bash ./config-unbound-dns-onprem-rhel-centos.sh"
  }
SETTINGS
}