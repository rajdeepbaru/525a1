


# Installation


curl -O https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/karaf/0.21.0/karaf-0.21.0.tar.gz


tar -xvzf karaf-0.21.0.tar.gz

cd karaf-0.21.0/

sudo apt-get update
sudo apt-get upgrade
sudo apt install openjdk-17-jdk openjdk-17-jre -y

./bin/karaf
