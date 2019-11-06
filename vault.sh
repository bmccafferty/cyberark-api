#!/bin/bash
#Cyberark API Bash Script
#Brian McCafferty - 2019

# -------------------------------------------
# Pull in vault.cfg file and set up variables
# -------------------------------------------

usage="$(basename "$0") [-h] [-s search] [-p account_id] -- Script to interact with the CyberArc Vault Service via the Command Line.

where:
    -h  show this help text
    -s  search (Find ID of account and get password)
    -p  get password (Requires ID of account)"
source config/vault.cfg
echo
echo "The following settings are being pulled from the config/vault.cfg settings file"
echo "Vault URL: "$VAULT_URL
echo "Vault Authentication Method: "$VAULT_AUTH
echo "CyberArk Logon User: "$VAULT_USER
echo
echo "$usage"
echo


# -------------------------------------------
# Define Functions for CyberArk Interaction
# -------------------------------------------

pass_search() {
        #Grab Password
        echo "Logging onto CyberArk using URL "$VAULT_URL" and Username "$VAULT_USER
        echo "Remember after entering your password if required Auth via 2FA"
        echo -n Please enter your CyberArk Password:
        read -s VAULT_PASSWORD
        echo
        #Build & Run Logon and Store the Logon Token for future calls.
        CURL_CMD="curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"UserName": \"$VAULT_USER\","Password": \"$VAULT_PASSWORD\"}' '$VAULT_URL/PasswordVault/api/Auth/$VAULT_AUTH/Logon'"
        #echo $CURL_CMD
        RAW_LOGON_TOKEN="$(eval "$CURL_CMD")"
        #echo $RAW_LOGON_TOKEN
        LOGON_TOKEN=${RAW_LOGON_TOKEN:1:-1}
        #echo $LOGON_TOKEN
        #Build & Run the Password Pull.
        CURL_CMD="curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Authorization: $LOGON_TOKEN'  -d '{}'  '$VAULT_URL/PasswordVault/api/Accounts/$ACC_ID/Password/Retrieve'"
        #echo $CURL_CMD
        PULLED_PASS="$(eval "$CURL_CMD")"
        echo "The Password You Requested is: "${PULLED_PASS:1:-1}
        CURL_CMD="curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Authorization: $LOGON_TOKEN'  -d '{}'  '$VAULT_URL/PasswordVault/api/Auth/Logoff'"
        #echo $CURL_CMD
        LOGGED_OFF="$(eval "$CURL_CMD")"
}

acct_search() {
        #Grab Password
        echo "Logging onto CyberArk using URL "$VAULT_URL" and Username "$VAULT_USER
        echo "Remember after entering your password if required Auth via 2FA"
        echo -n Please enter your CyberArk Password:
        read -s VAULT_PASSWORD
        echo
        #Build & Run Logon and Store the Logon Token for future calls.
        CURL_CMD="curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"UserName": \"$VAULT_USER\","Password": \"$VAULT_PASSWORD\"}' '$VAULT_URL/PasswordVault/api/Auth/$VAULT_AUTH/Logon'"
        #echo $CURL_CMD
        RAW_LOGON_TOKEN="$(eval "$CURL_CMD")"
        #echo $RAW_LOGON_TOKEN
        LOGON_TOKEN=${RAW_LOGON_TOKEN:1:-1}
        #echo $LOGON_TOKEN
        #Build & Run the Password Pull.
        CURL_CMD="curl -s -X GET --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Authorization: $LOGON_TOKEN' '$VAULT_URL/PasswordVault/api/Accounts?search=$SEARCH_TERM'"
        #echo $CURL_CMD
        PULLED_ACCT="$(eval "$CURL_CMD")"
        echo $PULLED_ACCT
        echo "Your Search Results"
        echo $PULLED_ACCT | jq/jq-linux64 '.value[] | {AccountID: .id, AccountName: .name, Address: .address, Username: .userName}'
        CURL_CMD="curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Authorization: $LOGON_TOKEN'  -d '{}'  '$VAULT_URL/PasswordVault/api/Auth/Logoff'"
        #echo $CURL_CMD
        LOGGED_OFF="$(eval "$CURL_CMD")"
}


# -------------------------------------------
# Define the Script Options and help menu
# -------------------------------------------

while getopts ':hsp:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) SEARCH_TERM=$2
       if [ "$#" -ne 2 ]; then
                echo "Please Enter A Search Term, If using multiple works please inclide in quotes e.g. \""Search For This\"""
                exit 2
       fi
       echo "Searching CyberArk For - "$SEARCH_TERM
       acct_search
       ;;
    p) ACC_ID=$2
       if [ "$#" -ne 2 ]; then
                echo "Please Enter an Account ID e.g. 76_6, if you do not know this please use a search to find it."
                exit 2
       fi
       re='^[0-9]+([_][0-9]+)?$'
       if ! [[ $ACC_ID =~ $re ]] ; then
                 echo "The Account ID is not in the correct format, Please Enter an Account ID e.g. 73_6, if you do not know this please use a search to find it."
                 exit 3
       fi
       echo "Searching CyberArk for Account ID - "$ACC_ID
       pass_search
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
