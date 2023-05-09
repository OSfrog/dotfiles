#!/bin/bash

source_folder="$HOME/.config/nvim/lua/custom"
destination_folder="$HOME/Desktop/dotfiles/nvim/custom"

# Remove the existing destination folder if it exists
if [ -e "$destination_folder" ]; then
    rm -rf "$destination_folder"
fi

# Copy the source folder to the destination
cp -r "$source_folder" "$destination_folder"

# Check if the copy command was successful
if [ $? -eq 0 ]; then
    echo "Folder has been successfully updated"
else
    echo "There was a problem updating the folder"
fi
