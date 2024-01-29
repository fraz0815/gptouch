#!/bin/bash

# Default values
GNOME_RANDR_PATH_DEFAULT="/usr/bin/gnome-randr.py"
OUTPUT_DISPLAY_DEFAULT="HDMI-1"
TOUCHSCREEN_DEVICE_DEFAULT="WingCool Inc. TouchScreen"

# Check for Zenity
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Please install Zenity to use this GUI feature."
    exit 1
fi

# Check for gnome-randr.py existence and executability
if ! [ -x "$GNOME_RANDR_PATH" ]; then
    echo "gnome-randr.py not found or not executable at $GNOME_RANDR_PATH. Aborting..."
    exit 1
fi


GNOME_RANDR_PATH="$GNOME_RANDR_PATH_DEFAULT"
OUTPUT_DISPLAY="$OUTPUT_DISPLAY_DEFAULT"
TOUCHSCREEN_DEVICE="$TOUCHSCREEN_DEVICE_DEFAULT"


# Function to update the udev rule for touchscreen calibration
update_touchscreen_calibration() {
    echo "ATTRS{name}==\"$TOUCHSCREEN_DEVICE\", ENV{LIBINPUT_CALIBRATION_MATRIX}=\"$1\"" | sudo tee /etc/udev/rules.d/99-touchscreen-orientation.rules
}

# Function to change orientation
update_orientation() {
    "$GNOME_RANDR_PATH" --output "$OUTPUT_DISPLAY" --rotate \"$1\" --persistent
}

echo "Select screen orientation:"
echo "1) Landscape (normal)"
echo "2) Portrait (right side up)"
read -p "Enter your choice (1-2): " orientation_choice

case $orientation_choice in
    1)
        rotation="normal"
        calibration_matrix="1 0 0 0 1 0"
        ;;
    2)
        rotation="right"
        calibration_matrix="0 1 0 -1 0 1"
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# Prompt for user action regarding the popup window
echo '### Attention ###'
echo 'A confirmation popup from gnome-randr.py may appear.'
echo 'Please confirm the screen rotation there, just hit Enter'
echo

# Check if the user wants to proceed
echo 'Do you want to update the touchscreen rotation and calibration?'
read -p "Enter 'y' to continue or 'n' to cancel: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo 'Updating udev rule for touchscreen calibration...'
    update_touchscreen_calibration "$calibration_matrix"
    echo
    echo 'Restarting udev service'
    sudo systemctl restart udev
    echo
    echo 'Rotating the display ...'
    update_orientation "$rotation"
    echo    
# Displaying hint to the user about the KVM switch
    zenity --info --text="The screen orientation has been updated.\nPlease press the KVM switch button twice to reinitialize the display settings. The button is located right next to the VESA monitor casing.\nOr simply replug USB-C power cable" --width=300
else
    zenity --info --text="Update cancelled. No changes were made."
fi


