sudo apt-get update -y

echo  -e "Done: update"

sudo apt-get upgrade -y

echo  -e "Done: upgrade"


sudo apt-get install openssh-server -y

echo  -e "Done: openssh-server installation"


sudo systemctl enable ssh

echo  -e "Done: ssh enabled"



sudo systemctl enable ssh --now

echo  -e "Done: ssh enabled now"


sudo systemctl start ssh

echo  -e "Done: ssh started"


sudo apt-get install vim git curl -y

echo  -e "Done: vim innstalled"

echo  -e "Done: all done"


#rm -dir -f -r 525a1-main/
#curl -O https://codeload.github.com/rajdeepbaru/525a1/zip/refs/heads/main
#unzip main
#rm main
#cd 525a1-main/


git config --global user.name "rajdeep"
git config --global user.email 212011005@iitdh.ac.in


ssh-keygen -t ed25519 -C "212011005@iitdh.ac.in"

eval "$(ssh-agent -s)"


ssh-add ~/.ssh/id_ed25519

cat /home/rajdeep/.ssh/id_ed25519.pub >> /home/rajdeep/Music/key01-git

cd

echo -e "git clone git@github.com:rajdeepbaru/525a1.git"
echo -e "ssh-keygen -R 10.240.60.114"
echo -e "ssh rajdeep@10.240.60.114"

