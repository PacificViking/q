#!/usr/bin/env python3

import os
import sys

ALARM = 75

newspeed = input("New fan speed (0-7, auto, disengaged): ")
os.system(f"echo level {newspeed} | sudo tee /proc/acpi/ibm/fan")

while True:
    a = os.popen("cat /sys/class/hwmon/hwmon*/temp*_input 2> /dev/null").read().split('\n')
    for i in a:
        try:
            if int(i) > ALARM*1000:
                os.system("notify-send \"Your computer is overheating!\"")
                sys.exit(0)
        except ValueError:
            pass
