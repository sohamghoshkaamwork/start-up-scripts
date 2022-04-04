#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Setup Finder Commands
# Show Library Folder in Finder
chflags nohidden ~/Library

# Show Hidden Files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# install xcode CLI
xcode-select —-install

# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully"
else
    echo "Homebrew already installed!"
fi

brew config

# Updating Homebrew.
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae.
echo "Upgrading Homebrew..."
brew upgrade

# Update the Terminal
# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Need to logout now to start the new SHELL..."
logout

# Install Git
echo "Installing Git..."
brew install git

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git
cd fonts || exit
sh -c ./install.sh

# Install ruby
if test ! "$(which ruby)"; then
    echo "Installing Ruby..."
    brew install ruby
    echo "Adding the brew ruby path to shell config..."
    echo 'export PATH='"/usr/local/opt/ruby/bin:$PATH" >>~/.bash_profile
else
    echo "Ruby already installed!"
fi


PACKAGES=(
    "git"
    "tmux"
    "bat"
    "macvim"
    "mysql"
    "fzf"
    "ctags"
    "mosh"
)

echo "Installing packages... "
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."

CASKS=(
    "iterm2"
    "brave-browser"
    "visual-studio-code"
    "joplin"
    "keepassx"
    "macdown"
    "firefox"
    "caffeine"
    "mjolnir"
    "hammerspoon"
    "spectacle"
)

echo "Installing cask apps..."
brew install --cask --appdir="/Applications" ${CASKS[@]}

MacApplicationToolList=(
    409183694 # Keynote
    409203825 # Numbers
    409201541 # Pages
    497799835 # Xcode
    # 1450874784 # Transporter
    # 1274495053 # Microsoft To Do
    1295203466 # Microsoft Remote Desktop 10
    985367838 # Microsoft Outlook
)

echo ${MacApplicationToolList[@]}

brew install mas
mas install ${MacApplicationToolList[@]}

echo "######### Save screenshots to ${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

echo "######### Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF"
defaults write com.apple.screencapture type -string "png"


# Remove outdated versions from the cellar.
echo "Running brew cleanup..."
brew cleanup
echo "You're done!"