# My NixOS Configuration

My personal NixOS setup using a custom profile-based architecture to manage my infrastructure across different environments.

## What This Is

This is my personal NixOS configuration that I use to manage:
- My laptop (`nixos-lt`) - Main development machine with NVIDIA GPU
- WSL environment (`nixos-wsl`) - Development environment on Windows
- Live CD (`nixos-livecd`) - Recovery and installation media

The setup uses a custom profile system I designed to keep configurations modular and reusable.

## How It Works

### Profile System
I created a profile-based architecture where systems are composed of:

**Package Profiles** (what gets installed):
- `base` - Core system packages (always included)
- `desktop` - GUI apps, Hyprland, desktop tools
- `development` - Programming languages, editors, dev tools
- `security` - Security monitoring and hardening tools
- `livecd` - Live environment specific packages

**User Profiles** (how my user is configured):
- `base` - Basic user setup (always included)
- `admin` - Administrative access and tools
- `developer` - Development-focused environment and dotfiles

### My Systems
Systems are defined using my `mkSystem` function:

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

## Key Features I Built

### Custom Utilities
- `discoverNixFiles` - Automatically finds and includes profile files
- `mkSystem` - System generator with validation
- `mkHome` - Home Manager configuration generator
- Validation functions to catch configuration errors

### Impermanence Setup
Root filesystem gets wiped on every boot, with selective persistence:
- `/persist/home` - My user data and dotfiles
- `/persist/system` - Important system state
- Ensures my system stays clean and reproducible

### Modular Nixvim
Custom Neovim configuration using nixvim with:
- LSP for all my languages
- Modern completion with blink.cmp
- Tree-sitter syntax highlighting
- Custom keybindings and plugins

## Directory Structure

```
├── flake.nix              # Main system definitions
├── hosts/                 # Per-host configurations
├── profiles/packages/     # System package profiles
├── profiles/user/         # User configuration profiles  
├── users/lucas/           # My user config and dotfiles
├── modules/               # Custom modules (nixvim, nvidia)
├── lib/                   # My utility functions
└── tasks/                 # Automation scripts
```

## Common Commands

```bash
# Enter development shell
nix develop

# List available tasks
run

# Switch system configuration
run switch nixos-lt

# Build Live ISO
run build-iso

# Build VM image
run build-vm

# Format code
alejandra .
```

## Image Generation

I can build multiple deployment formats:
- **ISOs**: `run build-iso`, `run build-install-iso`
- **VMs**: `run build-vm`, `run build-virtualbox`
- **Cloud**: `run build-cloud-aws`, `run build-cloud-gce`

## Why This Architecture

I built this modular system because:
- **Consistency** - Same base setup across all my machines
- **Flexibility** - Easy to enable/disable features per host
- **Maintainability** - Changes in one profile affect all systems using it
- **Documentation** - The code documents my entire infrastructure
- **Reproducibility** - Can rebuild any system from scratch

## Notes

This is my personal configuration. If you're looking at this as a reference:
- The profile system might be useful for your own setup
- Check out the utility functions in `lib/`
- The validation system helps catch configuration mistakes
- The impermanence setup ensures system cleanliness

The configuration is always evolving as I refine my setup and add new features.