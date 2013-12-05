#!/bin/bash
# ---------------------------------------------------------------------------- #
# Author: Marco Pappalardo
# 
# Mac OS X 10.9 Mavericks - Finder and Trash Icon changer
# 
# Usage:
# The script will search for correctly named icons in the current directory 
# and will replace them in the System folder while doing the backup of the originals
# 
# A different icon folder can be specified with the -d option
# ---------------------------------------------------------------------------- #

# Initalization of variables
OS_VERSION=`sw_vers -productVersion`
SOURCE_FOLDER="."
DEST_FOLDER="/System/Library/CoreServices/Dock.app/Contents/Resources"

icons_list=(finder.png finder@2x.png trashempty.png trashempty@2x.png trashfull.png trashfull@2x.png)
normal_icons_list=(finder.png trashempty.png trashfull.png)
retina_icons_list=(finder@2x.png trashempty@2x.png trashfull@2x.png)
NORMAL_SIZE="128"
RETINA_SIZE="256"

# This method only works for Mavericks, since they have changed the icons name
if [ $OS_VERSION != "10.9" ]; then
  echo "The operating system is not 10.9 Mavericks. This script, at the moment, only works for 10.9"
  exit 1
fi

# -d option for specify folder
while getopts ":-d:" opt; do
  case $opt in
    d)
      SOURCE_FOLDER="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ $SOURCE_FOLDER == "." ]; then
  echo "[ ] Using local dir. To specify a folder use the option -d icon_folder"
fi

if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "[X] $SOURCE_FOLDER is not a directory"
  exit 1 
fi

echo "---------------------------- "
echo "Source Folder: $SOURCE_FOLDER"
echo "Destination Folder: $DEST_FOLDER"
echo "---------------------------- "
# Checking that all required icons are available 
FILE_ERROR=false

# for icon in ${icons_list[@]}
# do
#   if [ ! -f $DEST_FOLDER/$icon ] ; then
#     echo "[X] $DEST_FOLDER/$icon missing!"
#     FILE_ERROR=true
#   fi
# done

for icon in ${icons_list[@]}
do
  if [ ! -f $SOURCE_FOLDER/$icon ] ; then
    echo "[X] $SOURCE_FOLDER/$icon missing!"
    FILE_ERROR=true
  fi
done

# Checking icons size for normal icons
for icon in ${normal_icons_list[@]}
do
  if [ -f $SOURCE_FOLDER/$icon ] ; then
    if [ $(sips -g pixelHeight $SOURCE_FOLDER/$icon | tail -n1 | cut -d" " -f4) != $NORMAL_SIZE ] ; then
      echo "[X] $SOURCE_FOLDER/$icon is not $NORMAL_SIZE px height"
      FILE_ERROR=true
    fi
    
    if [ $(sips -g pixelWidth $SOURCE_FOLDER/$icon | tail -n1 | cut -d" " -f4) != $NORMAL_SIZE ] ; then
      echo "[X] $SOURCE_FOLDER/$icon is not $NORMAL_SIZE px width"
      FILE_ERROR=true
    fi    
  fi
done

# Checking icons size for retina icons
for icon in ${retina_icons_list[@]}
do
  if [ -f $SOURCE_FOLDER/$icon ] ; then
    if [ $(sips -g pixelHeight $SOURCE_FOLDER/$icon | tail -n1 | cut -d" " -f4) != $RETINA_SIZE ] ; then
      echo "[X] $SOURCE_FOLDER/$icon is not $RETINA_SIZE px height"
      FILE_ERROR=true
    fi

    if [ $(sips -g pixelWidth $SOURCE_FOLDER/$icon | tail -n1 | cut -d" " -f4) != $RETINA_SIZE ] ; then
      echo "[X] $SOURCE_FOLDER/$icon is not $RETINA_SIZE px width"
      FILE_ERROR=true
    fi    
  fi
done

# Stop the execution here after printing all the errors and doing anything!
if $FILE_ERROR ; then  
  echo "[-] Please fix the errors before proceeding"
  exit 1
fi

# Backing up current icons if there are not already some backups
for icon in ${icons_list[@]}
do
  if [ ! -f "$DEST_FOLDER/$icon.backup" ] ; then
    cp "$DEST_FOLDER/$icon" "$DEST_FOLDER/$icon.backup"
    printf "[-] Backup:    %-20s to     %-30s \n" "$icon" "$icon.backup"
  fi
done

# Moving the new icons 
for icon in ${icons_list[@]}
do
  cp "$SOURCE_FOLDER/$icon" "$DEST_FOLDER/$icon"
  printf "[-] Replacing: %s --> %s \n" "$SOURCE_FOLDER/$icon" "$DEST_FOLDER/$icon"
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

