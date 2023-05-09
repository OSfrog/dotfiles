#!/usr/bin/env bash

# Define source and destination directories
src="../nvim/custom/"
dest="$HOME/.config/nvim/lua/custom/"

# Remove the destination directory if it exists
rm -rf "$dest"

# Copy the source directory to the destination
if cp -r "$src" "$dest"; then
  echo "Nvim dotfiles successfully updated"
else
  echo "Failed to update Nvim dotfiles"
fi
