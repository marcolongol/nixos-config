{...}:
# Image Building Tasks
{
  perSystem = {pkgs, ...}: {
    mission-control.scripts = {
      "build-iso" = {
        description = "Build NixOS Live ISO image";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-iso";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building NixOS Live ISO..."
            nixos-generate -f iso --flake ".#nixos-livecd" -o result
            echo "ISO built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-install-iso" = {
        description = "Build NixOS Installation ISO image";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-install-iso";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building NixOS Installation ISO..."
            nixos-generate -f install-iso --flake ".#nixos-livecd" -o result
            echo "Installation ISO built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-vm" = {
        description = "Build VM image (QCOW2 format)";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-vm";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building VM image (QCOW2)..."
            nixos-generate -f qcow --flake ".#nixos-livecd" -o result
            echo "VM image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-vmware" = {
        description = "Build VMware image";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-vmware";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building VMware image..."
            nixos-generate -f vmware --flake ".#nixos-livecd" -o result
            echo "VMware image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-virtualbox" = {
        description = "Build VirtualBox image (VDI format)";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-virtualbox";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building VirtualBox image..."
            nixos-generate -f virtualbox --flake ".#nixos-livecd" -o result
            echo "VirtualBox image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-cloud-aws" = {
        description = "Build AWS AMI image";
        category = "Cloud Images";

        exec = pkgs.writeShellApplication {
          name = "build-cloud-aws";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building AWS AMI image..."
            nixos-generate -f amazon --flake ".#nixos-livecd" -o result
            echo "AWS AMI built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-cloud-gce" = {
        description = "Build Google Cloud Engine image";
        category = "Cloud Images";

        exec = pkgs.writeShellApplication {
          name = "build-cloud-gce";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building Google Cloud Engine image..."
            nixos-generate -f gce --flake ".#nixos-livecd" -o result
            echo "GCE image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-cloud-azure" = {
        description = "Build Microsoft Azure image";
        category = "Cloud Images";

        exec = pkgs.writeShellApplication {
          name = "build-cloud-azure";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building Microsoft Azure image..."
            nixos-generate -f azure --flake ".#nixos-livecd" -o result
            echo "Azure image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-cloud-do" = {
        description = "Build DigitalOcean image";
        category = "Cloud Images";

        exec = pkgs.writeShellApplication {
          name = "build-cloud-do";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building DigitalOcean image..."
            nixos-generate -f "do" --flake ".#nixos-livecd" -o result
            echo "DigitalOcean image built successfully! Check the ./result directory for the image."
          '';
        };
      };

      "build-all-images" = {
        description = "Build all common image formats (ISO, VM, VirtualBox)";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "build-all-images";

          runtimeInputs = [pkgs.nixos-generators pkgs.git];

          text = ''
            echo "Building all common image formats..."

            echo "1/4 Building Live ISO..."
            nixos-generate -f iso --flake ".#nixos-livecd" -o result-iso

            echo "2/4 Building Installation ISO..."
            nixos-generate -f install-iso --flake ".#nixos-livecd" -o result-install-iso

            echo "3/4 Building VM image (QCOW2)..."
            nixos-generate -f qcow --flake ".#nixos-livecd" -o result-qcow

            echo "4/4 Building VirtualBox image..."
            nixos-generate -f virtualbox --flake ".#nixos-livecd" -o result-virtualbox

            echo ""
            echo "All images built successfully!"
            echo "Check the following directories for your images:"
            echo "  Live ISO: ./result-iso/"
            echo "  Install ISO: ./result-install-iso/"
            echo "  VM (QCOW): ./result-qcow/"
            echo "  VirtualBox: ./result-virtualbox/"
          '';
        };
      };

      "clean-images" = {
        description = "Clean all built image artifacts";
        category = "Image Building";

        exec = pkgs.writeShellApplication {
          name = "clean-images";

          runtimeInputs = [pkgs.coreutils];

          text = ''
            echo "Cleaning image build artifacts..."
            rm -rf result result-*
            echo "All image artifacts cleaned."
          '';
        };
      };
    };
  };
}
