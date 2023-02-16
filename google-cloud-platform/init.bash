#!bin/bash

set -x

mkdir ssh
ssh-keygen -t rsa -f ssh/gcloud_id_rsa -q -P ""

cp scripts/.template.env.txt scripts/.env

TOKEN=`echo $RANDOM | md5sum | head -c 30; echo;`
PWDGRA=`echo $RANDOM | md5sum | head -c 20; echo;`
PWDINF=`echo $RANDOM | md5sum | head -c 20; echo;`

sed -i -e "s/##TOKEN##/$TOKEN/g" scripts/.env
sed -i -e "s/##PWDGRA##/$PWDGRA/g" scripts/.env
sed -i -e "s/##PWDINF##/$PWDINF/g" scripts/.env

sed -n 's/\r$//' scripts/.env

echo "Init done."

terraform init
terraform apply -auto-approve -compact-warnings