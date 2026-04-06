#!/bin/bash
eval $(gnome-keyring-daemon --start --components=secrets,pkcs11,ssh)
export GNOME_KEYRING_CONTROL
export SSH_AUTH_SOCK
