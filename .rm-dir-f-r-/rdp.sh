sudo apt update
sudo apt install xfce4 xfce4-goodies -y

sudo apt install xrdp -y
sudo systemctl status xrdp
sudo systemctl start xrdp
cd ~
echo "xfce4-session" | tee .xsession
sudo systemctl restart xrdp
curl ifconfig.me
sudo ufw allow from your_local_ip/32 to any port 3389
sudo ufw status


#sudo ufw delete 1
#sudo ufw status numbered
#sudo ufw status
#sudo ufw allow from 10.200.233.40/20 to any port 3389
sudo ufw status
#sudo ufw allow 3389
