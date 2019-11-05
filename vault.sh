#!/bin/bash
#Cyberark API Bash Script
#Brian McCafferty - 2019
# -------------------------------------------
# Pull in vault.cfg file and set up variables
# -------------------------------------------
source config/vault.cfg
echo
echo "The following settings are being pulled from the config/vault.cfg settings file"
echo "Vault URL: "$VAULT_URL
echo "Vault Authentication Method: "$VAULT_AUTH
echo "CyberArk Logon User: "$VAULT_USER
echo
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
# -----------
# Main Menu
# -----------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}
 
# do something in two()
two(){
	echo "two() called"
        pause
}
 
# function to display menus
show_menus() {
	#clear
        echo
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Set Terminal"
	echo "2. Reset Terminal"
	echo "3. Exit"
}
# read input from the keyboard and take a action
read_options(){
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) one ;;
		2) two ;;
		3) exit 0;;
		*) echo -e "${RED}Error... Please Make a Valid Selection${STD}" && sleep 2
	esac
}
 
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main App Loop
# ------------------------------------
while true
do
 
	show_menus
	read_options
done
