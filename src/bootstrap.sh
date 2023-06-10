# parse arguments
while true; do
    if [ $# -eq 0 ]; then
		break
    fi
    case "$1" in
        -h | --help)
            display_help
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            exit 1
            ;;
        *)  # No more options
            break
            ;;
    esac
done

ready_to_install=""
unsure_to_install=""

print_logo

if ! is_tty; then
	print_error "This script must be run in a tty."
	exit 1
fi

print_status "Checking the environment and mirrors to install..."
for software in $supported_softwares; do
	# check if the software is ready to deploy
	if has_command _${software}_check && _${software}_check; then
		ready_to_install="$ready_to_install ${software}"
	elif ! has_command _${software}_check; then
		unsure_to_install="$unsure_to_install ${software}"
	fi
done

if [ -z "$ready_to_install" -a -z "$unsure_to_install" ]; then
	print_warning "No software is ready to install."
	print_info "Supported softwares:"
	echo $supported_softwares | xargs echo "   " | fold -s -w 80 # TODO: check if has fold
	exit 0
fi

if [ -n "$ready_to_install" ]; then
	print_info "The following software(s) are ready to install:"
	echo "   $ready_to_install"
fi

if [ -n "$unsure_to_install" ]; then
	print_info "The following software(s) are unsure to install:"
	echo "   $unsure_to_install"
fi


# vim: set filetype=sh ts=4 sw=4 noexpandtab:
