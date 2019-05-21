#!/bin/bash
Action=$1
BROWN='\033[0;33m'
NC='\033[0m'
RED='\033[1;31m'

help() {
  printf "\n${RED}Usage:${NC} \n\nFOR CREATION:\n--------------------\n\n\t${BROWN}./run.sh create name=<Name> user=<Username> program=<digits/catsdogs/objdet> model_serving_url=<URL> [ OPTIONAL-ARG ]\n\n\n${NC}"
   printf "OPTIONAL-ARG:\n-----------------\n\n"
   printf " ${BROWN} --image=<Image Name>\t\t\t\tContainer image to use, should be in public repo${NC}\n\n"
   printf "FOR DELETION:\n-----------------\n\n\t${BROWN}./run.sh delete name=<Name> user=<Username>\n\n${NC}"
  exit

}


if [ $Action != "create" -a $Action != "delete" ]; then
	echo -e "\n\e[91m Invalid Operation\e[0m\n"
	help
fi
for var in "$@"
do
   IFS== read var1 var2 <<<$var
   if [ $var1 == "name" ];then
	   Name=$var2
   elif [ $var1 == "user" ]; then
	   Username=$var2
   elif [ $var1 == "program" ]; then
	 Tag=$var2
   elif [ $var1 == "model_serving_url" ]; then
	Tfurl=$var2
   elif [ $var1 == "--image" ]; then
        Image=$var2
   fi	
done

if [ -z "$Name" ]; then
	echo -e "\n\e[91mname Not Found\e[0m"
	help
elif [ -z "$Username" ]; then
	echo -e "\n\e[91mUser Not Found\e[0m"
	help
fi

if [ $Action == "delete" ]; then
    Username="d3-$Username"
	sudo ./argo delete $Name -n $Username --kubeconfig=${HOME}/.dkube/kubeconfig
	exit 128
fi

if [ -z "$Tfurl" ]; then
	echo -e "\n\e[91mModel serving url Not Found\e[0m"
	help
elif [ -z "$Tag" ]; then
	echo -e "\n\e[91mProgram Not Found\e[0m"
	help
elif [ -z "$Image" ]; then
	echo "applying default Image"
	Image="ocdr/dkube-d3inf:1.1"
fi
if [ $Tag != "digits" -a $Tag != "catsdogs" -a $Tag != "objdet" ]; then
	echo -e "\n\e[91mRequested Program Not Valid\e[0m( INFO :supported programmes  digits, catsdogs, objdet )\n"
	help
fi

MASTERNODE=`sudo kubectl get nodes --kubeconfig=${HOME}/.dkube/kubeconfig -o json | jq '.items[] | .status .addresses[] | select(.type=="ExternalIP") | .address'`

MASTERNODE=`echo $MASTERNODE | tr -d '["]'`

echo $PORT
echo $MASTERNODE
Service=$Username
echo "service ac is $Service"
Username="d3-$Username"
echo "username is $Username"

MODEL=`echo $Tfurl | awk -F/ '{print $NF}'`
sudo ./argo submit start-inference-test-wf.yaml -p container=$Image -p model=$MODEL -p tf-serving-url=$Tfurl --name $Name --namespace $Username --kubeconfig=${HOME}/.dkube/kubeconfig  --serviceaccount $Service


PORT=""
while [ ${#PORT} -eq 0 ]; do
     sleep 1
     PORT=`sudo kubectl  get svc $Name -n $Username --kubeconfig=${HOME}/.dkube/kubeconfig -o json | jq -j '.spec.ports[0] |.nodePort'`
done

if [ $Tag == "catsdogs" ]; then
    echo -e "Available @ http://$MASTERNODE:$PORT/catsanddogs\n"
elif [ $Tag == "objdet" ]; then
    echo -e "Available @ http://$MASTERNODE:$PORT/objdetect\n"
else
	echo -e "Available @ http://$MASTERNODE:$PORT/digits\n"
fi
echo
