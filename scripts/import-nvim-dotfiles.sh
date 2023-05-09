#!/bin/bash

# Define the source and destination directories
src="../nvim/custom/"
dest="~/.config/nvim/lua/custom/"

# Create the destination directory if it doesn't exist
mkdir -p "$dest"

# Copy the files, replacing any existing files
cp -r "$src"/* "$dest"
