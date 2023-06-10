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
ready_to_uninstall=""
unsure_to_install=""
install_things=""

print_logo

# TODO: support run in script
if ! is_tty; then
	print_error "This script must be run in a tty."
	exit 1
fi

print_status "Checking the environment and mirrors to install..."
for software in $supported_softwares; do
	# check if the software is ready to deploy
	if has_command _${software}_check && _${software}_check; then
		if has_command _${software}_is_deployed && _${software}_is_deployed; then
			continue
		fi
		ready_to_install="$ready_to_install ${software}"
	elif ! has_command _${software}_check; then
		unsure_to_install="$unsure_to_install ${software}"
	fi
done

if [ -z "$ready_to_install" -a -z "$unsure_to_install" ]; then
	print_warning "No software is ready to install."
	print_supported
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

recover() {
	ready_to_uninstall=""
	for software in $supported_softwares; do
		# check if the software is ready to recover
		if has_command _${software}_can_recover && _${software}_can_recover; then
			ready_to_uninstall="$ready_to_uninstall ${software}"
		fi
	done

	print_info "The following software(s) are ready to recover:"
	echo "   $ready_to_uninstall"

	get_input "What do you want to uninstall?
    <softwares> for specific softwares, use space to separate multiple softwares."

	uninstall_things="$input"

	# uninstall
	for software in $uninstall_things; do
		if has_command _${software}_can_recover && _${software}_can_recover; then
			print_success "${software} can be recoverd."
		else 
			print_error "${software} can not be recoverd."
			continue
		fi

		if has_command _${software}_uninstall; then
			print_status "recover ${software}..."
			result=0
			_${software}_uninstall || result=$?
			if [ $result -eq 0 ]; then
				print_success "Successfully uninstalled ${software}."
			else
				print_error "Failed to uninstall ${software}."
				confirm "Do you want to continue?" || exit 1
			fi
		else
			print_error "No uninstallation method for ${software}."
		fi
	done
}

install() {
	install_path="$HOME/.local/bin"
	install_target="$install_path/hustmirror"
	if [ ! -d "$install_path" ]; then
		mkdir -p "$install_path"
	fi
	has_command curl || { 
		print_error "curl is required." 
		exit 1
	}
	print_status "Downloading latest hust-mirror..."
	curl -sL ${http}://${domain}/get.sh > "$install_target" || {
		print_error "Failed to download hust-mirror."
		exit 1
	}
	chmod +x "$install_target"
	print_success "Successfully install hust-mirror."
	has_command hustmirror || print_warning "It seems ~/.local/bin is not in your path."
	print_success "Now, you can use \`hustmirror\` in your command line"
}

while true; do
	input=""
	get_input "What do you want to install? [all] 
    (a)ll for ready, all! (a!) for all software(s), including unsure ones.
    <softwares> for specific softwares, use space to separate multiple softwares.
    (l)ist for forcely list all softwares, even is not supported here.
    
    Other options:
    (r)ecover for uninstall software mirror.
    (i)nstall or update hust-mirror locally
    (q)uit for exit."

	# parse input
	if [ -z "$input" ]; then
		input="all"
	fi

	case "$input" in
		a | all)
			install_things="$ready_to_install"
			break
			;;
		a! | all!)
			install_things="$ready_to_install $unsure_to_install"
			break
			;;
		l | list)
			print_supported
			;;
		q | quit)
			exit 0
			;;
		r | recover)
			recover
			exit 0
			;;
		i | install)
			install
			exit 0
			;;
		*)
			install_things="$input"
			break
			;;
	esac
done


# install
for software in $install_things; do
	if has_command _${software}_install; then
		print_status "Deploying ${software}..."
		result=0
		_${software}_install || result=$?
		if [ $result -eq 0 ]; then
			print_success "Successfully deployed ${software}."
		else
			print_error "Failed to deploy ${software}."
			confirm "Do you want to continue?" || exit 1
		fi
	else
		print_error "No installation method for ${software}."
	fi
done


# vim: set filetype=sh ts=4 sw=4 noexpandtab:
