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


sudo apt-get install vim -y

echo  -e "Done: vim innstalled"


sudo apt-get install git -y

echo  -e "Done: git installed"


sudo apt-get install curl -y

echo  -e "Done: curl installed"



echo  -e "Done: all done"


#rm -dir -f -r 525a1-main/
#curl -O https://codeload.github.com/rajdeepbaru/525a1/zip/refs/heads/main
#unzip main
#rm main
#cd 525a1-main/



