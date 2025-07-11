#!/usr/bin/env bash

# Simple wallpaper control wrapper
# Provides easy commands for common wallpaper operations

set -euo pipefail

# Main function
main() {
    case "${1:-help}" in
        "next"|"n")
            # Change to next random wallpaper
            if command -v wallpaper-manager >/dev/null 2>&1; then
                wallpaper-manager
            else
                "$(dirname "$0")/wallpaper-manager.sh"
            fi
            ;;
        "center"|"c")
            # Change wallpaper with center transition
            if command -v wallpaper-manager >/dev/null 2>&1; then
                wallpaper-manager -t center
            else
                "$(dirname "$0")/wallpaper-manager.sh" -t center
            fi
            ;;
        "left"|"l")
            # Change wallpaper with left transition
            if command -v wallpaper-manager >/dev/null 2>&1; then
                wallpaper-manager -t left
            else
                "$(dirname "$0")/wallpaper-manager.sh" -t left
            fi
            ;;
        "right"|"r")
            # Change wallpaper with right transition
            if command -v wallpaper-manager >/dev/null 2>&1; then
                wallpaper-manager -t right
            else
                "$(dirname "$0")/wallpaper-manager.sh" -t right
            fi
            ;;
        "info"|"i")
            # Show current wallpaper info
            if command -v swww >/dev/null 2>&1; then
                swww query
            else
                echo "swww not available"
            fi
            ;;
        "help"|"h"|*)
            cat << EOF
wallctl - Simple wallpaper control commands

USAGE:
    wallctl COMMAND

COMMANDS:
    next, n       Change to random wallpaper
    center, c     Change wallpaper with center transition
    left, l       Change wallpaper with left transition  
    right, r      Change wallpaper with right transition
    info, i       Show current wallpaper info
    help, h       Show this help

EXAMPLES:
    wallctl next      # Random wallpaper change
    wallctl center    # Center transition
    wallctl info      # Show current wallpaper

EOF
            ;;
    esac
}

main "$@"
