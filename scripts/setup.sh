## CONFIG LOCAL ENV
echo "[*] Config local environment..."

echo "We would like to create an admin user for youyr vault, you will be able to login to the UI with it"
read -p "Enter prefered admin_username: " admin_user
read -p "Enter prefered password: " password

alias vault='docker-compose exec vault vault "$@"'
export VAULT_ADDR=http://127.0.0.1:8200

## INIT VAULT
echo "[*] Init vault..."
vault operator init -address=${VAULT_ADDR} > ./data/keys.txt
export VAULT_TOKEN=$(grep 'Initial Root Token:' ./data/keys.txt | awk '{print substr($NF, 1, length($NF))}')

## UNSEAL VAULT
echo "[*] Unseal vault..."
vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 1:' ./data/keys.txt | awk '{print $NF}')
vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 2:' ./data/keys.txt | awk '{print $NF}')
vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 3:' ./data/keys.txt | awk '{print $NF}')

## AUTH
echo "[*] Auth..."
vault login -address=${VAULT_ADDR} ${VAULT_TOKEN}

## Create an admin user for ur vault
echo "[*] Create user... Remember to change the defaults!!"
vault auth enable  -address=${VAULT_ADDR} userpass
vault policy write -address=${VAULT_ADDR} admin ./config/admin.hcl
vault write -address=${VAULT_ADDR} auth/userpass/users/${admin_user} password=${password} policies=admin

## Create a backup token 
echo "[*] Create backup token..."
vault token create -address=${VAULT_ADDR} -display-name="backup_token" | awk '/token/{i++}i==2' | awk '{print "backup_token: " $2}' >> ./data/keys.txt

## Mount a secret path for your secrets
echo "[*] Creating new mount point..."
vault secrets list -address=${VAULT_ADDR}
vault secrets enable -address=${VAULT_ADDR} -path=credentials -description="my personal secrets" generic


