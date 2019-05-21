#! /bin/bash
sudo apt-get install -y jq
wget https://github.com/argoproj/argo/releases/download/v2.2.1/argo-linux-amd64 --no-check-certificate
mv argo-linux-amd64 argo
chmod +x argo
sudo kubectl --help
if [ $? -ne 0 ]; then
	sudo apt-get -y update && sudo apt-get install -y apt-transport-https curl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get -y update
	sudo apt-get install -y kubectl=1.12.5-00
fi
