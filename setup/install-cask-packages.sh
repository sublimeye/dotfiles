#!/usr/bin/env bash

CASKS=(
    1password
    iterm2
    spectacle
    slack
    skype
    spotify
)

echo "Do you wish to install cask packages [${CASKS[*]}]?"
select yn in "Yes" "No"; do
    case $yn in
        Yes)
        echo "Installing cask apps..."
        brew cask install ${CASKS[@]}
        echo "Done installing cask apps."        
        break
        ;;
        No)
        echo ""
        break
        ;;
    esac
done
