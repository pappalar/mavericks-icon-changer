#!/bin/bash
# ---------------------------------------------------------------------------- #
# Author: Marco Pappalardo
# 
# Mac OS X 10.9 Mavericks - Finder and Trash Icon changer
# 
# Usage:
# The script restore the original icons
# ---------------------------------------------------------------------------- #

# Initalization of variables
OS_VERSION=`sw_vers -productVersion`
SOURCE_FOLDER="./originals"
DEST_FOLDER="/System/Library/CoreServices/Dock.app/Contents/Resources"

icons_list=(finder.png finder@2x.png trashempty.png trashempty@2x.png trashfull.png trashfull@2x.png)

# This method only works for Mavericks, since they have changed the icons name
if [ $OS_VERSION != "10.9" ]; then
  echo "The operating system is not 10.9 Mavericks. This script, at the moment, only works for 10.9"
  exit 1
fi


if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "[X] $SOURCE_FOLDER is missing!"
  exit 1 
fi

# Checking that all required icons are available 
FILE_ERROR=false


for icon in ${icons_list[@]}
do
  if [ ! -f $SOURCE_FOLDER/$icon ] ; then
    echo "[X] $SOURCE_FOLDER/$icon missing!"
    FILE_ERROR=true
  fi
done

# Stop the execution here after printing all the errors and doing anything!
if $FILE_ERROR ; then  
  echo "[-] Please fix the errors before proceeding"
  exit 1
fi


# restoring icons
for icon in ${icons_list[@]}
do
  cp "$SOURCE_FOLDER/$icon" "$DEST_FOLDER/$icon"
  printf "[-] Restoring: %s --> %s \n" "$SOURCE_FOLDER/$icon" "$DEST_FOLDER/$icon"
done

# Giving correct ownership
# for icon in ${icons_list[@]}
# do
#   chown root:wheel $DEST_FOLDER/$icon
#   printf "[-] chown root:wheel %s \n" "$DEST_FOLDER/$icon" 
# done

# Applying modification
echo "---------------------------- "
echo "[-] Restarting Dock and Finder"
killall Finder
killall Dock


echo "[-] All done!"

