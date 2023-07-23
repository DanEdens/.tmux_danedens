#!/bin/bash

# Function to compare version strings
function version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}

# Get glibc and glib versions
glibc_version=$(ldd --version | head -n 1 | rev | cut -d ' ' -f1 | rev)
glib_version=$(pkg-config --modversion glib-2.0)

# Print current versions
echo "Current GLIBC version: $glibc_version"
echo "Current GLIB version: $glib_version"

# Check if glibc is less than 2.26 and glib is greater than or equal to 2.50.1
if version_gt $glib_version "2.50.1" && version_gt "2.26" $glibc_version ; then
    echo "Your GLIBC version is lower than 2.26 while your GLIB version is 2.50.1 or higher."
    echo "This may cause issues with tmux and VTE based terminal emulators."
    
    # Update locale
    export LC_CTYPE=en_US.UTF-8
    echo "Set LC_CTYPE to en_US.UTF-8"

    # Optionally, prompt to update glibc
    # read -p "Would you like to attempt to update GLIBC? This may require sudo privileges. [y/N] " -n 1 -r
    # echo
    # if [[ $REPLY =~ ^[Yy]$ ]]
    # then
    #     sudo apt-get update && sudo apt-get upgrade libc6
    # fi
fi
