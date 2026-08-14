#!/usr/bin/env bash

if [ ! -f "$HOME/.ssh/id_ed25519_personal" ]; then
    echo "Generating Personal SSH Key..."
    ssh-keygen -t ed25519 -C "s.rawat3.142@live.in" -f "$HOME/.ssh/id_ed25519_personal" -N ""
fi

# Target chezmoi's source directory
CHEZMOI_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"

if [ -d "$CHEZMOI_DIR/.git" ]; then
    git -C "$CHEZMOI_DIR" config core.sshCommand "ssh -i $HOME/.ssh/id_ed25519_personal -o IdentitiesOnly=yes"
    git -C "$CHEZMOI_DIR" config user.name "dragneelfps"
    git -C "$CHEZMOI_DIR" config user.email "s.rawat3.142@live.in"
    git -C "$CHEZMOI_DIR" remote set-url origin git@github.com:dragneelfps/dot.git
fi
