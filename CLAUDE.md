# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

This is a NixOS configuration repository using Nix flakes. The project uses Mission Control for task automation.

### Development Environment
- `nix develop` - Enter development shell
- `run` - List all available Mission Control tasks

### System Management
- `run switch <system>` - Switch NixOS configuration (requires NixOS)
  - Available systems: `nixos-wsl`, `nixos-lt`, `nixos-livecd`
  - Example: `run switch nixos-lt`

### Image Building
- `run build-iso` - Build NixOS Live ISO image
- `run build-install-iso` - Build NixOS Installation ISO
- `run build-vm` - Build VM image (QCOW2 format)
- `run build-virtualbox` - Build VirtualBox image (VDI format)
- `run build-vmware` - Build VMware image
- `run build-all-images` - Build all common image formats
- `run clean-images` - Clean all built image artifacts

### Cloud Images
- `run build-cloud-aws` - Build AWS AMI image
- `run build-cloud-gce` - Build Google Cloud Engine image
- `run build-cloud-azure` - Build Microsoft Azure image
- `run build-cloud-do` - Build DigitalOcean image

### Code Formatting
- `alejandra .` - Format all Nix files (configured as default formatter)

## Architecture Overview

This is a modular NixOS configuration with the following key architecture patterns:

### Configuration Structure
- **Flake-based**: Uses `flake.nix` as entry point with flake-parts for modular organization
- **Multi-host support**: Configurations for WSL, laptop, and live CD environments
- **Profile system**: Modular package and user profiles for different use cases
- **Library system**: Custom utilities in `lib/` for configuration generation

### Key Directories
- `hosts/` - Host-specific configurations (nixos-wsl, nixos-lt, nixos-livecd)
- `profiles/packages/` - System package profiles (base, desktop, development, security, livecd)
- `profiles/user/` - User-specific profiles (base, admin, developer)
- `users/lucas/` - User configuration with dotfiles and scripts
- `modules/` - Custom NixOS modules (nixvim, nvidia)
- `lib/` - Utility functions for system/home generation
- `tasks/` - Mission Control automation scripts
- `overlays/` - Package overlays and customizations

### Profile System
The configuration uses a profile-based architecture:

**Package Profiles** (system-level):
- `base` - Core system packages (always included)
- `desktop` - Desktop environment and GUI applications
- `development` - Development tools and environments
- `security` - Security and monitoring tools
- `livecd` - Live CD specific packages

**User Profiles**:
- `base` - Base user configuration (always included)  
- `admin` - Administrative user setup
- `developer` - Developer-specific user configuration

### System Generation Pattern
Systems are generated using `lib.utils.mkSystem` with:
- **hostname**: Unique system identifier
- **profiles**: List of package profiles to include
- **users**: User configurations with their profiles
- **extraModules**: Additional NixOS modules

Example from flake.nix:712:
```nix
nixos-lt = lib.utils.mkSystem {
  hostname = "nixos-lt";
  profiles = [ "desktop" "development" "security" ];
  users = [{
    name = "lucas";
    profiles = [ "admin" "developer" ];
    extraGroups = [ "wheel" "docker" ];
  }];
  extraModules = [ ./modules/nvidia ];
};
```

### Key Features
- **Impermanence**: Root filesystem wiped on boot, selective persistence via `/persist`
- **Home Manager**: Declarative user environment management
- **Disko**: Declarative disk partitioning
- **Nixvim**: Modular Neovim configuration
- **Image Generation**: Multiple output formats for deployment

### Development Patterns
- All configurations use the custom library functions in `lib/utils.nix`
- Validation functions in `lib/validations.nix` ensure configuration correctness
- Mission Control scripts provide consistent task automation
- Profiles are automatically discovered using `discoverNixFiles` utility
- System persistence configured via `mkSystemPersistence` helper

### Important Notes
- The `base` profile is always included for both packages and users
- Validation can be disabled for image builds using `enableValidation = false`
- All systems use the unstable nixpkgs channel
- Home Manager configurations are separate but can be integrated with NixOS