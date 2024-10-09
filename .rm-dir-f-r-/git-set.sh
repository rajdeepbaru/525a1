git config --global user.name "rajdeep"
git config --global user.email 212011005@iitdh.ac.in


ssh-keygen -t ed25519 -C "212011005@iitdh.ac.in"

eval "$(ssh-agent -s)"


ssh-add ~/.ssh/id_ed25519

cat /home/rajdeep/.ssh/id_ed25519.pub >> /home/rajdeep/Music/key01-git
