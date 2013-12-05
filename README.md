# Mac OS X - Finder and Trash Icon changer

Scripts for changing and restoring Finder and Trash icons in Mac OS X 10.9

The script will search for correctly named icons in the current directory and will replace them in the System folder.

* A different icon folder can be specified with the -d option
* Originals are backed up
* A copy of the originals is provided (for the restore script)

Since it is modifying the System folder, it must be executed with sudo

### Usage:

To change the system icons with the example one:

    sudo bash replace_icons.sh -d example_icons/


------------

Examples icons are property of [Sticker Pack 1][] - by David Lanham - IconFactory

All copyrights remain the property of their respective holders. 


[Sticker Pack 1]: http://iconfactory.com/freeware/preview/stkr1
