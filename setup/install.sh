#!/usr/bin/env bash

# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

read -p "Have you already installed Xcode through the App Store? " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Exiting. Please install XCode from the AppStore first and then run install"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Running brew update"
brew update

# Install GNU core utilities (those that come with OS X are outdated)
# brew tap homebrew/dupes
# brew install coreutils
# brew install gnu-sed --with-default-names
# brew install gnu-tar --with-default-names
# brew install gnu-indent --with-default-names
# brew install gnu-which --with-default-names
# brew install gnu-grep --with-default-names

# # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# brew install findutils

/bin/bash ./install-brew-packages.sh
/bin/bash ./install-cask-packages.sh

# echo "Installing fonts..."
# brew tap caskroom/fonts
# FONTS=(
#     font-inconsolidata
#     font-roboto
#     font-clear-sans
# )
# brew cask install ${FONTS[@]}

# echo "Installing Ruby gems"
# RUBY_GEMS=(
#     cocoapods
# )
# sudo gem install ${RUBY_GEMS[@]}

# echo "Installing global npm packages..."
# npm install marked -g

echo "Configuring OSX..."

echo osx: Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

echo osx: Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# echo osx: Show filename extensions by default
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo osx: Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

if [[ ! -d ~/projects ]]
then
    echo Creating ~/projects folder
    [[ ! -d ~/projects ]] && mkdir ~/projects
fi

echo "Warning: Did not copy .zshrc to ~/dir -> do it manually or update this script"

echo "Bootstrapping complete"