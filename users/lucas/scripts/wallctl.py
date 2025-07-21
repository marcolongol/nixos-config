#! /usr/bin/env python3

import argparse
import os
import sys
import subprocess
import psutil
import shutil
import time
import random
import logging
from pprint import pprint as pp
from typing import Optional

logging.basicConfig(level=logging.INFO, format="[$levelname] $message", style="$")

WALLPAPER_DIR = os.path.expanduser("~/Pictures/Wallpapers")

VALID_TRANSITION_TYPES = [
    "simple",
    "left",
    "right",
    "top",
    "bottom",
    "center",
    "outer",
    "any",
    "random",
]


def main():
    parser = argparse.ArgumentParser(description="Control the swww wallpaper daemon.")
    subparsers = parser.add_subparsers(dest="command")

    # Subcommand for starting the daemon
    next_parser = subparsers.add_parser("next", help="Set the next wallpaper")
    next_parser.add_argument(
        "--transition-type",
        choices=VALID_TRANSITION_TYPES,
        default="random",
        help="Set the wallpaper mode",
    )
    next_parser.set_defaults(func=lambda args: _set_wallpaper(args.transition_type))

    # Subcommand for displaying help
    help_parser = subparsers.add_parser("help", help="Display this help message")
    help_parser.set_defaults(func=lambda: parser.print_help())

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    # Execute the appropriate function based on the command
    args.func(args)


def _info():
    info = {"daemon_running": _is_sww_daemon_running()}
    pp(info)


def _is_sww_daemon_running():
    """Check if the swww daemon is running."""
    for proc in psutil.process_iter(["name"]):
        if proc.info["name"] == "swww-daemon":
            return True
    return False


def _start_swww_daemon():
    """Start the swww daemon."""
    logging.info("Starting swww daemon...")
    # check if we have swww installed
    if not shutil.which("swww-daemon"):
        logging.error("swww-daemon is not installed. Please install it first.")
        sys.exit(1)
    subprocess.Popen(
        ["swww-daemon"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    time.sleep(0.5)


def _set_wallpaper(mode: Optional[str] = "center"):
    """Set the wallpaper using provided mode."""
    if not _is_sww_daemon_running():
        logging.info("swww daemon is not running. Starting it now...")
        _start_swww_daemon()

    if mode not in VALID_TRANSITION_TYPES:
        logging.error(
            f"Invalid mode: {mode}. Valid modes are: {', '.join(VALID_TRANSITION_TYPES)}"
        )
        return
    wallpaper = _get_random_wallpaper()
    if wallpaper:
        logging.info(f"Setting wallpaper: {wallpaper} with mode: {mode}")
        # check if wal is installed
        if not shutil.which("wal"):
            logging.error("wal is not installed. Please install it first.")
            sys.exit(1)
        # check if swww is installed
        if not shutil.which("swww"):
            logging.error("swww is not installed. Please install it first.")
            sys.exit(1)
        # run wal to generate colors
        os.system(f"wal -i {wallpaper}")
        os.system(f"swww img {wallpaper} --transition-type {mode}")

    else:
        logging.error("No valid wallpaper found to set.")


def _get_random_wallpaper() -> Optional[str]:
    """Get a random wallpaper from the wallpaper directory."""
    if not os.path.exists(WALLPAPER_DIR):
        logging.error(f"Wallpaper directory does not exist: {WALLPAPER_DIR}")
        return None
    wallpapers = [
        f
        for f in os.listdir(WALLPAPER_DIR)
        if f.lower().endswith((".png", ".jpg", ".jpeg"))
    ]
    if not wallpapers:
        logging.error("No wallpapers found in the directory.")
        return None
    # return a random wallpaper
    return os.path.join(WALLPAPER_DIR, random.choice(wallpapers))


if __name__ == "__main__":
    main()
