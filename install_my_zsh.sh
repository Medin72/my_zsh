#!/bin/bash

#
# This script installs:
# Meslo mono-font
# Zshell and my config file
# Starship
#

# Using set -e to exit immediately if any command fails during the script's execution
set -e
# Enable nullglob (if directory is empty, do ignore the pattern)
shopt -s nullglob
# Define directories and files
SRC_FONT_DIR="./res/fonts/Meslo"
DST_FONT_DIR="$HOME/.local/share/fonts/Meslo"
SRC_ZSHRC="./res/.zshrc"
DST_ZSHRC="$HOME/.zshrc"
SRC_STSP="./res/starship.toml"
DST_STSP="$HOME/.config/starship.toml"
# Define colors
COLOR_NC="\e[0m"
COLOR_BRIGHT="\e[1m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"

echo "================================================================"
echo " ⭐ Starship Shell Prompt Installer is going to install..."
echo "    • git & curl (needed for the installer)"
echo "    • Fonts ('MesloLGSNerdFontMono')"
echo "    • Z Shell"
echo "    • Ohmyzsh"
echo "    • Starship"
echo "================================================================"

read -r -p "Do you want to continue? (y/N): " answer

# Convert answer to lowercase
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" == "y" ]]; then
  echo ""

  # Install git & curl
  echo "----------------------------------------------------------------"
  echo "Installing git and curl..."
  if sudo apt update; then
    if sudo apt install git curl -y; then
      echo -e "${COLOR_GREEN}✅ SUCCESS! Git and curl was installed.${COLOR_NC}"
    else
      echo -e "${COLOR_YELLOW}⚠️  WARNING: Git and curl installation failed!${COLOR_NC}"
    fi
  else
    echo -e "${COLOR_RED}❌ ERROR! Failed to run apt update! Check internet connection.${COLOR_NC}"
    exit 1
  fi

  # Copying fonts
  echo "----------------------------------------------------------------"
  echo "Installing fonts to $DST_FONT_DIR..."
  mkdir -p "$DST_FONT_DIR"
  for source_file in "$SRC_FONT_DIR"/*; do
    # Check if it's actually is a file (skip subdirectories)
    if [[ -f "$source_file" ]]; then
      filename=$(basename "$source_file")
      destination_file="$DST_FONT_DIR/$filename"
      if [[ ! -e "$destination_file" ]]; then
        echo "--> Installing: $destination_file"
        cp "$source_file" "$destination_file"
      else
        echo "--- Skipping: $destination_file (already exists)"
      fi
    fi
  done
  echo ""
  echo -e "${COLOR_BRIGHT}ℹ️  Fonts installed! Please change your terminal fonts to 'MesloLGSNerdFontMono'.${COLOR_NC}"

  # Installing Z Shell
  echo ""
  echo "----------------------------------------------------------------"
  echo "Installing Z Shell..."
  if sudo apt install zsh -y; then
    echo -e "${COLOR_GREEN}✅ SUCCESS! Z Shell was installed.${COLOR_NC}"
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: Z Shell installation failed!${COLOR_NC}"
  fi

  # Installing Ohmyzsh
  echo ""
  echo "----------------------------------------------------------------"
  echo "Installing Ohmyzsh..."
  if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo -e "${COLOR_GREEN}✅ SUCCESS! Ohmyzsh was installed.${COLOR_NC}"
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: Ohmyzsh installation failed!${COLOR_NC}"
  fi

  # Install Plugins
  echo ""
  echo "----------------------------------------------------------------"
  echo "Installing plugins..."
  if git clone https://github.com/zsh-users/zsh-autosuggestions\${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
    echo -e "${COLOR_GREEN}✅ SUCCESS! zsh-autosuggestions was installed.${COLOR_NC}"
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: zsh-autosuggestions installation failed!${COLOR_NC}"
  fi
  if git clone https://github.com/zsh-users/zsh-syntax-highlighting\${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
    echo -e "${COLOR_GREEN}✅ SUCCESS! zsh-syntax-highlighting was installed.${COLOR_NC}"
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: zsh-syntax-highlighting installation failed!${COLOR_NC}"
  fi

  # Configure Z Shell
  echo ""
  echo "----------------------------------------------------------------"
  echo "Configure $DST_ZSHRC..."
  if rm "$DST_ZSHRC"; then
    if cp "$SRC_ZSHRC" "$DST_ZSHRC"; then
      echo -e "${COLOR_GREEN}✅ SUCCESS! $DST_ZSHRC was configured.${COLOR_NC}"
    else
      echo -e "${COLOR_YELLOW}⚠️  WARNING: $DST_ZSHRC configuration failed!${COLOR_NC}"
    fi
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: $DST_ZSHRC is write protected!${COLOR_NC}"
  fi

  # Install Starship
  echo ""
  echo "----------------------------------------------------------------"
  echo "Installing Starship..."
  if curl -sS https://starship.rs/install.sh | sh; then
    echo -e "${COLOR_GREEN}✅ SUCCESS! Starship was installed.${COLOR_NC}"
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: Starship installation failed!${COLOR_NC}"
  fi

  # Configure Starship
  echo ""
  echo "----------------------------------------------------------------"
  echo "Configure $DST_STSP..."
  if rm "$DST_STSP"; then
    if cp "$SRC_STSP" "$DST_STSP"; then
      echo -e "${COLOR_GREEN}✅ SUCCESS! $DST_STSP was configured.${COLOR_NC}"
    else
      echo -e "${COLOR_YELLOW}⚠️  WARNING: $DST_STSP configuration failed!${COLOR_NC}"
    fi
  else
    echo -e "${COLOR_YELLOW}⚠️  WARNING: $DST_STSP is write protected!${COLOR_NC}"
  fi

  # Set zsh as default shell
  echo ""
  echo "----------------------------------------------------------------"
  echo "Now you may want to set Z Shell to your default shell."
  echo "The shell will reload, so you may want to check for"
  echo "error messages above before you do that."
  read -r -p "Do you want to set Z Shell to default? (y/N): " answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  if [[ "$answer" == "y" ]]; then
    chsh -s $(which zsh)
  else
    echo "I hear you. Just type 'chsh -s $(which zsh)' when you're ready."
  fi

else
  echo ""
  echo "Aborting script, nothing installed."
fi

echo ""
echo "Script finished, have a nice day!"

exit 0
