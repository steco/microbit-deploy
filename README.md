# microbit-deploy
Deployment script for Micro:bit .hex files

## Background
This script takes the location of a `.hex` file as a parameter, and copies it to two locations:
  * A [Micro:bit](http://microbit.org) device attached to the computer
  * A secondary (ie backup) location - generally expected to be a network drive
  
The script is intended to be associated with the `.hex` files, so once a program has been written (in https://makecode.microbit.org/# for example), simply downloading it and selecting "Open" will automatically deploy it to the Micro:bit.
