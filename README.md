# cyberark-api
Home to Cyberark API Bash Script project to interact with the cyberark API

Nothing too exciting just a bash script with a main menu to allow easy searching of the CyberArk Vault via the API at the command line rather than via the web portal.

Main Config of the script is via the vault.cfg file held in the config directory.

You can set:
#The URL of the main CyberArk Server.
VAULT_URL=https://bdm.scot/test

#The Auth type to be used with the API Options are - CyberArk/Windows/LDAP/RADIUS

VAULT_AUTH=RADIUS

#By Default the script takes your logged on username for use to logon to CyberArk you can update below to hardcode a username
VAULT_USER=$USER

To Run the Script just enter the directory and run the script
./vault.sh