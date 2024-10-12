curl -O https://raw.githubusercontent.com/89luca89/distrobox/main/install
sudo bash install


distrobox-list --root

echo -e "run: distrobox-create --root --name ubuntuu18 --image ubuntu:18.04"
echo -e "run:distrobox enter --root ubuntuu18"
echo "sudo apt install neofetch vim git curl -y"
echo -e "run: cat /etc/lsb-release"
echo -e "logout"

rm install
