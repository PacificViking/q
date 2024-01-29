#!/usr/bin/env python3

import os
import sys

ALARM = 80

newspeed = input("New fan speed (0-7, auto, disengaged): ")
os.system(f"echo level {newspeed} | sudo tee /proc/acpi/ibm/fan")

# options thinkpad_acpi fan_control=1

while True:
    a = os.popen("cat /sys/class/hwmon/hwmon*/temp*_input 2> /dev/null").read().split('\n')
    for i in a:
        try:
            if int(i) > ALARM*1000:
                os.system(f"notify-send \"Your computer is overheating! ({int(i)/1000})\"")
                sys.exit(0)
        except ValueError:
            pass
