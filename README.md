# New version here, should work on x11 and wayland fully automatic, WIP
[`gptouch-python`](https://github.com/fraz0815/gptouch-python)

# gptouch.sh - Screen Orientation and Touchscreen Calibration Tool (updated for Gnome 46)

`gptouch.sh` is a script designed to manage screen orientation and touchscreen calibration on Linux systems using GNOME on Wayland. It provides a graphical interface for easy interaction and customization.

## Features

- Rotate the screen to various orientations: landscape, portrait (right or left), or inverted.
- Automatically adjust the touchscreen calibration to align with the screen orientation.
- Customize script paths and device identifiers via a GUI.
- Apply changes and reboot the system with user confirmation.

## Requirements

- [`gnome-randr-rust`](https://github.com/maxwellainatchi/gnome-randr-rust): Required for screen arrangement and rotation in GNOME on Wayland. Please note that `gnome-randr` is not developed by the author of `gptouch.sh`, and full credit for `gnome-randr-rust` goes to its respective creators.
- `Zenity`: Used for creating the script's GUI. It is commonly pre-installed on many Linux distributions.
- `sudo` privileges: Necessary for modifying system configurations and performing a reboot.

## Installation

1. Ensure Zenity, Cargo and gnome-randr are installed on your system:
   - Debian: `apt install zenity`, Arch: `pacman -S zenity` etc.
   - Cargo: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
   - gnome-randr: `cargo install gnome-randr`
     
3. Download `gptouch.sh` and place it in a preferred directory.
4. Make the script executable:
`chmod +x /path/to/gptouch.sh`

## Usage

1. Run the script:
`/path/to/gptouch.sh`

2. If prompted, choose to modify the default settings for the script path, output display, and touchscreen device.
3. Select the desired screen orientation from the GUI options.
4. Confirm the changes and, if necessary, approve the system reboot to apply them.

## Hints

1. Get current output name, e.g. `HDMI-1` or `DP-3` etc:
`gnome-randr`

3. Get touchscreen device name:
`lsusb`
or 
`sudo dmesg | grep -i touch`

## Notes

- This script is specifically tailored for GNOME on Wayland. Compatibility may vary based on system configurations and GNOME/Wayland versions.
- It is recommended to test the script in a controlled environment before using it in a critical setup.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](link-to-issues-page) for contributing.

## License

This project is available under the [MIT License](LICENSE). Feel free to use and modify `gptouch.sh` as needed.
