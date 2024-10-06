#!/bin/bash

APPNAME=cloudup

checkperms(){

if [ "$EUID" -ne 0 ];
    then
    echo "Please run installation with sudo permissions"
    exit 1
fi
}

install(){
    echo "Installing cloudupload"
    checkperms
    if [ ! -f cloudupload.sh ];
    then
    echo "cloudupload.sh not found. Cancelling script."
    exit 1
    fi

    sudo cp myapp.sh /usr/local/bin/$APPNAME
    sudo chmod +x /usr/local/bin/$APPNAME
    if [ -f "/usr/local/bin/$APPNAME"];
        then
        echo "Installation for $APPNAME successful!"
}

uninstall(){
    echo "Uninstalling cloudupload..."
    checkperms
    sudo rm myapp.sh /usr/local/bin/$APPNAME
    if [ ! -f "/usr/local/bin/$APPNAME "];
        then
        echo "Installation for $APPNAME successful!"
}

case "$1" in
install)
    install
    ;;
uninstall)
    uninstall
    ;;
*)
    echo "Usage: cu_install.sh (install/uninstall)"
    ;;
    esac


