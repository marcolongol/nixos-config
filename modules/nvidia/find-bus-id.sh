#!/usr/bin/env bash

# NVIDIA Bus ID Helper Script
# This script helps you find the correct bus IDs for NVIDIA hybrid graphics setup

echo "=== GPU Bus ID Discovery ==="
echo ""

echo "1. Listing all graphics controllers:"
lspci | grep -E "(VGA|3D)" | while IFS= read -r line; do
    echo "   $line"
done

echo ""
echo "2. Converting bus IDs to NixOS format:"
echo "   Format: XX:YY.Z -> PCI:X:Y:Z (remove leading zeros)"
echo ""

lspci | grep -E "(VGA|3D)" | while IFS= read -r line; do
    # Extract bus ID (format: XX:YY.Z)
    bus_id=$(echo "$line" | cut -d' ' -f1)
    
    # Convert to NixOS format
    # XX:YY.Z -> PCI:X:Y:Z (remove leading zeros)
    nix_format=$(echo "$bus_id" | sed 's/^0*\([0-9]\)/\1/' | sed 's/:0*\([0-9]\)/::\1/g' | sed 's/\.\([0-9]\)/::\1/' | sed 's/::/:/g' | sed 's/^/PCI:/')
    
    # Get device description
    description=$(echo "$line" | cut -d' ' -f2- | cut -d':' -f2-)
    
    echo "   Bus ID: $bus_id -> NixOS format: $nix_format"
    echo "   Device:$description"
    echo ""
done

echo "3. Example NixOS configuration:"
echo ""

# Try to auto-detect Intel and NVIDIA
intel_bus=""
nvidia_bus=""

while IFS= read -r line; do
    bus_id=$(echo "$line" | cut -d' ' -f1)
    nix_format=$(echo "$bus_id" | sed 's/^0*\([0-9]\)/\1/' | sed 's/:0*\([0-9]\)/::\1/g' | sed 's/\.\([0-9]\)/::\1/' | sed 's/::/:/g' | sed 's/^/PCI:/')
    
    if echo "$line" | grep -qi "intel"; then
        intel_bus="$nix_format"
    elif echo "$line" | grep -qi "nvidia"; then
        nvidia_bus="$nix_format"
    fi
done < <(lspci | grep -E "(VGA|3D)")

cat << EOF
   hardware.nvidia-custom = {
     enable = true;
     hybrid = {
       enable = true;
       mode = "offload"; # or "sync" or "reverse-sync"
       busId = {
EOF

if [ -n "$intel_bus" ]; then
    echo "         intel = \"$intel_bus\";"
else
    echo "         intel = \"PCI:0:2:0\"; # Replace with your Intel GPU bus ID"
fi

if [ -n "$nvidia_bus" ]; then
    echo "         nvidia = \"$nvidia_bus\";"
else
    echo "         nvidia = \"PCI:1:0:0\"; # Replace with your NVIDIA GPU bus ID"
fi

cat << EOF
       };
     };
   };

EOF

echo "4. Additional commands to test NVIDIA setup:"
echo ""
echo "   # Check if NVIDIA driver is loaded:"
echo "   nvidia-smi"
echo ""
echo "   # Test OpenGL with NVIDIA (offload mode):"
echo "   nvidia-offload glxinfo | grep \"OpenGL renderer\""
echo ""
echo "   # Test Vulkan support:"
echo "   vulkan-tools # Then run: vkcube"
echo ""
echo "   # List available GPUs:"
echo "   glxinfo | grep \"OpenGL renderer\""
