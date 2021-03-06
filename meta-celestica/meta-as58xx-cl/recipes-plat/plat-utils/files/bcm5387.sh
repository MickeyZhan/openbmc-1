#!/bin/sh

source /usr/local/fbpackages/utils/ast-functions

status_switch() {
	prompt=1
	while getopts "f" opts; do
		case $opts in
			f)
				prompt=0
				shift
				;;
			*)
				prompt=1
				;;
		esac
	done
	if [ "$1" = "mdio" ]; then
		gpio_set F2 1
	elif [ "$1" = "eeprom" ]; then
		gpio_set F2 0
	else
		echo "Mode doesn't support!"
		return 1
	fi
	if [ $prompt -eq 1 ]; then
		printf "Need to reset BCM5389(Y/n) "
		read -t 5 -p "reset BCM5387(Y/n) " confirm
		if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
			printf "Reset......"
			gpio_set AA1 0
			sleep 1
			gpio_set AA1 1
			printf "OK\n"
		else
			printf "Timeout or Cancel"
			exit 1
		fi
	else
		printf "Reset......"
		gpio_set AA1 0
		sleep 1
		gpio_set AA1 1
		printf "OK\n"
	fi

	return 0
}

command="$1"
case "$command" in
	--mode)
		shift
		status_switch $@
		;;
	*)
		bcm5396_util_py3.py $@
		;;
esac
