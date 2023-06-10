print_logo() {
	echo ' _   _ _   _ ____ _____ __  __ ___ ____  ____   ___  ____  '
	echo '| | | | | | / ___|_   _|  \/  |_ _|  _ \|  _ \ / _ \|  _ \ '
	echo '| |_| | | | \___ \ | | | |\/| || || |_) | |_) | | | | |_) |'
	echo '|  _  | |_| |___) || | | |  | || ||  _ <|  _ <| |_| |  _ < '
	echo '|_| |_|\___/|____/ |_| |_|  |_|___|_| \_\_| \_\\___/|_| \_\'
	echo
	echo "hustmirror-cli ${script_version} build ${build_time}"
}

display_help() {
	print_logo
	echo "A CLI Bash script to generate a configuration file"
	echo "for software repository on different distributions"
	echo
	echo "Usage: $0 [option...] " >&2
	echo
	echo "   -h, --help                 Display help message"
	echo
}

source_os_release() {
	# /etc/os-release does exist in most Linux distributions, and BSD variants
	test -e /etc/os-release && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
	source "${os_release}"
}

confirm() {
	# call with a prompt string or use a default
	read -r -p "${1:-Are you sure? [y/N]} " response
	case "${response}" in
		[yY][eE][sS]|[yY])
			true
			;;
		*)
			false
			;;
	esac
}

confirm_y() {
	# call with a prompt string or use a default
	read -r -p "${1:-Are you sure? [Y/n]} " response
	case "${response}" in
		[nN][oO]|[nN])
			false
			;;
		*)
			true
			;;
	esac
}

is_root() {
	if [ "$EUID" -ne 0 ]; then
		return 0
	fi
		return 1
}

has_command() {
	result=0
	command -v "${1}" >/dev/null 2>&1 || result=$?
	return $result
}

has_sudo() {
	result=0
	has_command sudo || result=$?
	return $result
}

has_curl() {
	result=0
	has_command curl || result=$?
	return $result
}

has_git() {
	result=0
	has_command git || result=$?
	return $result
}

has_sed() {
	result=0
	has_command sed || result=$?
	return $result
}

is_tty() {
	result=0
	[ -t 1 ] || result=$?
	return $result
}

ESC=$(printf "\033")

echo_red() {
	if is_tty; then
		echo -e "\033[0;31m${1}\033[0m"
	else
		echo "${1}"
	fi
}

echo_green() {
	if is_tty; then
		echo -e "\033[0;32m${1}\033[0m"
	else
		echo "${1}"
	fi
}

echo_yellow() {
	if is_tty; then
		echo -e "\033[0;33m${1}\033[0m"
	else
		echo "${1}"
	fi
}

echo_blue() {
	if is_tty; then
		echo -e "\033[0;34m${1}\033[0m"
	else
		echo "${1}"
	fi
}

print_error() {
	echo_red "[ERR] ${1}"
}

print_warning() {
	echo_yellow "[WARN] ${1}"
}

print_success() {
	echo_green "[+] ${1}"
}

print_info() {
	echo_green "[!] ${1}"
}

print_status() {
	echo_blue "[*] ${1}"
}

print_question() {
	echo_red "[?] ${1}"
}

get_input() {
	print_question "${1}"
	read -r -p "[>] " input
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
