#!/opt/homebrew/bin/fish

# Define source and destination directories
set src "../../nvim/custom/"
set dest "$HOME/.config/nvim/lua/custom/"

# Remove the destination directory if it exists
rm -rf $dest

# Copy the source directory to the destination
if cp -r $src $dest
    echo "Nvim dotfiles successfully updated"
else
    echo "Failed to update Nvim dotfiles"
end
