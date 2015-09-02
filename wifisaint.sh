#!/bin/sh

. /usr/bin/wifisetup -noop


# variable setup
intfAp=-1
intfSta=-1
intfCount=0

bLog=1


# function to perform logging
#	argument 1: message to be logged
Log () {
	if [ $bLog == 1 ]; then
		echo "$1"
	fi

}



########################
##### Main Program #####

# check the current wireless setup
CheckCurrentUciWifi

Log "Current wireless Setup:: "
Log " intfAp:   $intfAp"
Log " intfSta:  $intfSta"


# enable AP network if no network is currently set
if 	[ $intfAp == -1 ] &&
	[ $intfSta == -1 ];
then
	Log "Onion Wifi Saint"
	Log "> Found no active wifi networks"

	# use the first available iface
	intfNew=$intfCount

	# identify new AP network name
	m1=$(cat /sys/class/net/eth0/address | awk -F':' '{ print $5 }' | awk '{print toupper($0)}')
	m2=$(cat /sys/class/net/eth0/address | awk -F':' '{ print $6 }' | awk '{print toupper($0)}')

	# setup the AP network
	#ssid="saintwifi"
	ssid="Omega-$m1$m2"
	auth="none"
	password=""

	Log "> Creating new AccessPoint network called $ssid"

	# perform network setup
	bJsonOutput=1
	UciSetupWifi $intfNew "ap"
fi

