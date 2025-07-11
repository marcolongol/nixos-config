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

    # VM formats - enable growPartition for dynamic sizing
    vmware = {
      services.cloud-init.enable = lib.mkForce false;
      boot.growPartition = lib.mkForce true;
      virtualisation.vmware.guest.enable = lib.mkForce true;
    };

    virtualbox = {
      services.cloud-init.enable = lib.mkForce false;
      boot.growPartition = lib.mkForce true;
      virtualisation.virtualbox.guest.enable = lib.mkForce true;
    };

    # QEMU/KVM optimization
    qcow2 = {
      services.cloud-init.enable = lib.mkDefault true;
      boot.growPartition = lib.mkForce true;
      services.qemuGuest.enable = lib.mkForce true;
    };
  };
}
