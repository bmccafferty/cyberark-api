#!/bin/bash
#Cyberark API Bash Script
#Brian McCafferty - 2019
source config/vault.cfg
echo "The following settings are being pulled from the config/vault.cfg settings file"
echo "Vault URL: "$VAULT_URL
echo "Vault Authentication Method: "$VAULT_AUTH
echo "CyberArk Logon User: "$VAULT_USER
