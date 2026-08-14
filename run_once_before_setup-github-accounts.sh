if [ ! -f "$HOME/.ssh/id_ed25519_personal" ]; then
    echo "Generating Personal SSH Key..."
    ssh-keygen -t ed25519 -C "s.rawat3.142@live.in" -f "$HOME/.ssh/id_ed25519_personal" -N ""
fi

git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes"
git config user.name "dragneelfps"
git config user.email "s.rawat3.142@live.in"
git remote set-url origin git@github.com:dragneelfps/dot.git
