# gptouch
Basic tool to change screen orientation and its touch input on gnome wayland desktops

### for gnome wayland and cheap touch screens without automatic input change after orientation change.
`xrandr` and `xinput` are things of the past in times of wayland.

so some basic stuff needs more work.

### uses gnome-randr.py which I take no credit for ...
U can use my fork here https://github.com/fraz0815/gnome-randr

remember where you put it, make sure it's executable.

### ... and adds a udev rule with the regarding calibration matrix in
`/etc/udev/rules.d/99-touchscreen-orientation.rules`

### defaults can be changed with a simple gui (zenity)
```
GNOME_RANDR_PATH_DEFAULT="/usr/bin/gnome-randr.py"
OUTPUT_DISPLAY_DEFAULT="HDMI-1"
TOUCHSCREEN_DEVICE_DEFAULT="WingCool Inc. TouchScreen"
```
