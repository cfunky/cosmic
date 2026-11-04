#!/usr/bin/env bash
username="$1"

# Clone the COSMIC DE setup repository.
echo "Cloning the COSMIC DE setup repository."
git clone https://github.com/cfunky/cosmic.git

# Install the custom package list.
echo "Installing packages for COSMIC DE."
pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout $(< ./cosmic/pkglist.txt)

# If autologin has been configured, update cosmic-greeter.toml accordingly.
if getent group autologin | grep -qw "${username}"; then
   echo "The 'autologin' group was detected. Configuring autologin in 'cosmic-greeter.toml'."
   cat << EOF >> /etc/greetd/cosmic-greeter.toml

[initial_session]
command = "start-cosmic"
user = "${username}"
EOF
fi

# Remove the COSMIC DE setup repository.
echo "Removing the COSMIC DE setup repositoy."
rm -rf cosmic

# Enable the cosmic-greeter service.
echo "Enabling the 'cosmic-greeter' service."
systemctl enable cosmic-greeter.service

echo "Installation complete."
