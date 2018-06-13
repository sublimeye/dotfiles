#!/usr/bin/env bash

PACKAGES=(
    n
    ack
    jq
    z
    zsh-syntax-highlighting
)

echo "Do you wish to install brew packages [${PACKAGES[*]}]?"
select yn in "Yes" "No"; do
    case $yn in
        Yes)
        echo "Installing packages..."
        brew install ${PACKAGES[@]}
        echo "Cleaning up..."
        brew cleanup
        echo "Done cleaning up"
        break
        ;;
        No)
        break
        ;;
    esac
done
