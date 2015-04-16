#!/bin/sh

# create an account alias
sudo dscl . -append /Users/$USER RecordName Pair pair

# configure sshd to only allow public-key authentication
sudo sed -E -i.bak 's/^#?(PasswordAuthentication|ChallengeResponseAuthentication).*$/\1 no/' /etc/sshd_config

# add pair user public key(s)
touch ~/.ssh/authorized_keys
gh-auth add --users githubuser --command="$( which tmux ) attach -t pair"

# https://news.ycombinator.com/item?id=4260090
