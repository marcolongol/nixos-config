# nixos-generators format configurations
# Ensures cloud-init is properly configured for different image types
{ lib, ... }: {

  imports = [ ];

  # Override format configurations to ensure proper cloud-init settings
  formatConfigs = {
    # Cloud formats - explicitly enable cloud-init
    amazon.services.cloud-init.enable = lib.mkForce true;
    azure.services.cloud-init.enable = lib.mkForce true;
    do.services.cloud-init.enable = lib.mkForce true;
    gce.services.cloud-init.enable = lib.mkForce true;
    openstack.services.cloud-init.enable = lib.mkForce true;
    cloudstack.services.cloud-init.enable = lib.mkForce true;

    # Installation formats - explicitly disable cloud-init
    install-iso.services.cloud-init.enable = lib.mkForce false;
    iso.services.cloud-init.enable = lib.mkForce false;
  };
}
