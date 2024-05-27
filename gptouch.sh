#!/bin/bash

# Default values, make suure cargo bin is included in your path, should be by default)
#G NOME_RANDR_PATH_DEFAULT="gnome-randr"
OUTPUT_DISPLAY_DEFAULT="HDMI-1"
TOUCHSCREEN_DEVICE_DEFAULT="WingCool Inc. TouchScreen"

# Check for Zenity
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Please install Zenity to use this GUI feature."
    exit 1
fi

# Ask user to modify defaults or continue
modify_defaults=$(zenity --question --text="Do you want to modify default settings?" --width=300; echo $?)
if [ "$modify_defaults" -eq 0 ]; then
    # GNOME_RANDR_PATH=$(zenity --entry --title="gnome-randr Path" --text="Enter the path to gnome-randr:" --entry-text="$GNOME_RANDR_PATH_DEFAULT")
    OUTPUT_DISPLAY=$(zenity --entry --title="Output Display" --text="Enter the output display identifier:" --entry-text="$OUTPUT_DISPLAY_DEFAULT")
    TOUCHSCREEN_DEVICE=$(zenity --entry --title="Touchscreen Device Name" --text="Enter the touchscreen device name:" --entry-text="$TOUCHSCREEN_DEVICE_DEFAULT")
else
    # NOME_RANDR_PATH="$GNOME_RANDR_PATH_DEFAULT"
    OUTPUT_DISPLAY="$OUTPUT_DISPLAY_DEFAULT"
    TOUCHSCREEN_DEVICE="$TOUCHSCREEN_DEVICE_DEFAULT"
fi

# Function to update the udev rule for touchscreen calibration
update_touchscreen_calibration() {
    echo "ATTRS{name}==\"$TOUCHSCREEN_DEVICE\", ENV{LIBINPUT_CALIBRATION_MATRIX}=\"$1\"" | sudo tee /etc/udev/rules.d/99-touchscreen-orientation.rules
}

echo "Select screen orientation:"
echo "1) Landscape (normal)"
echo "2) Portrait (right side up)"
echo "3) Portrait (left side up)"
echo "4) Inverted (upside down)"
read -p "Enter your choice (1-4): " orientation_choice

# gnome-randr modify [FLAGS] [OPTIONS] <connector>
case $orientation_choice in
    1)
        gnome-randr modify "$OUTPUT_DISPLAY" --rotate normal --persistent
        calibration_matrix="1 0 0 0 1 0"
        ;;
    2)
        gnome-randr modify "$OUTPUT_DISPLAY" --rotate left --persistent
        calibration_matrix="0 1 0 -1 0 1"
        ;;
    3)
       gnome-randr modify "$OUTPUT_DISPLAY" --rotate right --persistent
        calibration_matrix="0 -1 1 1 0 0"
        ;;
    4)
       gnome-randr modify "$OUTPUT_DISPLAY" --rotate inverted --persistent
        calibration_matrix="-1 0 1 0 -1 1"
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# Prompt for user action regarding the popup window
echo '### Attention ###'
echo 'A confirmation popup from gnome-randr may appear.'
echo 'Please confirm the screen rotation there, then return here and press Enter.'
read -p "After confirming the popup, press Enter to continue... "

# Check if the user wants to proceed after confirming the popup
echo 'Do you want to update the touchscreen calibration and reboot?'
read -p "Enter 'y' to continue or 'n' to cancel: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo 'Updating udev rule for touchscreen calibration...'
    update_touchscreen_calibration "$calibration_matrix"

    echo '### Preparing to Reboot ###'
    echo '### Please save all your work before proceeding ###'
    echo '### Press "y" to confirm and reboot or "n" to cancel ###'
    read -p "Reboot now? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo 'Rebooting...'
        sudo reboot
    else
        echo "Reboot cancelled. Changes will apply on next reboot."
    fi
else
    echo "Update and reboot cancelled."
fi

