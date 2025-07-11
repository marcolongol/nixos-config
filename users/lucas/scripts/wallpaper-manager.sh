#!/usr/bin/env bash

# Simple wallpaper manager for Hyprland using swww
# Changes wallpapers manually with configurable transition effects

set -euo pipefail

# Default settings
DEFAULT_WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
DEFAULT_TRANSITION="any"

# Available transition types for swww
TRANSITIONS="simple left right top bottom center outer any random"

# Supported image formats
SUPPORTED_FORMATS="jpg jpeg png gif webp bmp"

# Check if swww is available and daemon is running
check_swww() {
	if ! command -v swww >/dev/null 2>&1; then
		echo "Error: swww is not installed" >&2
		exit 1
	fi

	# Start daemon if not running
	if ! swww query >/dev/null 2>&1; then
		echo "Starting swww daemon..."
		swww-daemon &
		sleep 2
	fi
}

# Get list of wallpaper files from directory
get_wallpapers() {
	local dir="$1"
	local wallpapers=()

	if [[ ! -d "$dir" ]]; then
		return 1
	fi

	# Find all supported image files (follow symlinks)
	for ext in $SUPPORTED_FORMATS; do
		while IFS= read -r -d '' file; do
			wallpapers+=("$file")
		done < <(find "$dir" -maxdepth 1 \( -type f -o -type l \) -iname "*.${ext}" -print0 2>/dev/null || true)
	done

	if [[ ${#wallpapers[@]} -eq 0 ]]; then
		return 1
	fi

	printf '%s\n' "${wallpapers[@]}"
}

# Select random wallpaper from directory
select_random_wallpaper() {
	local dir="$1"
	local wallpapers

	if ! wallpapers=$(get_wallpapers "$dir"); then
		return 1
	fi

	local wallpaper_array=($wallpapers)
	local count=${#wallpaper_array[@]}
	local index=$((RANDOM % count))
	echo "${wallpaper_array[$index]}"
}

# Set wallpaper with specified transition
set_wallpaper() {
	local wallpaper="$1"
	local transition="${2:-$DEFAULT_TRANSITION}"

	if [[ ! -f "$wallpaper" ]]; then
		echo "Error: Wallpaper file not found: $wallpaper" >&2
		exit 1
	fi

	echo "Setting wallpaper: $(basename "$wallpaper") with transition: $transition"

	if [[ "$transition" == "random" ]]; then
		# Let swww choose random transition
		swww img "$wallpaper"
	else
		swww img "$wallpaper" --transition-type "$transition"
	fi

	echo "Wallpaper changed successfully!"
}

# Show help message
show_help() {
	cat <<EOF
wallpaper-manager - Simple wallpaper manager for Hyprland using swww

USAGE:
    wallpaper-manager [OPTIONS] [WALLPAPER_FILE]

OPTIONS:
    -d, --directory DIR     Directory containing wallpapers (default: ~/Pictures/Wallpapers)
    -t, --transition TYPE   Transition type (default: random)
    --list-transitions      List available transition types
    -h, --help              Show this help

TRANSITION TYPES:
    simple, left, right, top, bottom, center, outer, any, random

EXAMPLES:
    wallpaper-manager                           # Random wallpaper from default directory
    wallpaper-manager -d ~/Wallpapers          # Random wallpaper from custom directory  
    wallpaper-manager -t center                # Random wallpaper with center transition
    wallpaper-manager wallpaper.jpg            # Set specific wallpaper
    wallpaper-manager wallpaper.jpg -t left    # Set specific wallpaper with left transition

EOF
}

# Main function
main() {
	local wallpaper_dir="$DEFAULT_WALLPAPER_DIR"
	local transition="$DEFAULT_TRANSITION"
	local specific_wallpaper=""

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case $1 in
		-d | --directory)
			wallpaper_dir="$2"
			shift 2
			;;
		-t | --transition)
			transition="$2"
			shift 2
			;;
		--list-transitions)
			echo "Available transitions: $TRANSITIONS"
			exit 0
			;;
		-h | --help)
			show_help
			exit 0
			;;
		-*)
			echo "Error: Unknown option $1" >&2
			echo "Use -h for help" >&2
			exit 1
			;;
		*)
			# Assume it's a wallpaper file
			specific_wallpaper="$1"
			shift
			;;
		esac
	done

	# Validate transition type
	if [[ "$transition" != "random" ]] && [[ ! " $TRANSITIONS " =~ " $transition " ]]; then
		echo "Error: Invalid transition '$transition'. Use --list-transitions to see available options." >&2
		exit 1
	fi

	check_swww

	if [[ -n "$specific_wallpaper" ]]; then
		# Set specific wallpaper
		set_wallpaper "$specific_wallpaper" "$transition"
	else
		# Select random wallpaper from directory
		local wallpaper
		if ! wallpaper=$(select_random_wallpaper "$wallpaper_dir"); then
			echo "Error: No wallpapers found in $wallpaper_dir" >&2
			echo "Supported formats: $SUPPORTED_FORMATS" >&2
			exit 1
		fi
		set_wallpaper "$wallpaper" "$transition"
	fi
}

# Run main function
main "$@"
