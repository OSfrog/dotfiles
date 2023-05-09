#!/usr/bin/env fish

set source_folder /Users/tommy/.config/nvim/lua/custom
set destination_folder /Users/tommy/Desktop/dotfiles/nvim/custom

# Remove the existing destination folder if it exists
if test -e $destination_folder
    rm -rf $destination_folder
end

# Copy the source folder to the destination
cp -r $source_folder $destination_folder

echo "Folder has been successfully updated"
