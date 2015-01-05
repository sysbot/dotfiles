#!/bin/bash

# subkey and master key seperation setup [1][2]

MASTER="ngqbao@gmail.com"

echo "Creating a working copy of GNUPG without Master signing key"

if [ -z $MASTER_GNUPGHOME ]
then
  echo "$MASTER_GNUPGHOME is not set"
else
  git clone $MASTER_GNUPGHOME $HOME/.gnupg
  gpg --export-secret-subkeys $MASTER > subkeys
  gpg --export $MASTER > pubkeys
  gpg --delete-secret-key $MASTER
  gpg --import subkeys
  rm -rf subkeys
  gpg -K
fi

echo "To use the master key: "
echo "export GNUPGHOME=/location/dotgnupg"

# [1] https://wiki.debian.org/Subkeys
# [2] https://alexcabal.com/creating-the-perfect-gpg-keypair/
