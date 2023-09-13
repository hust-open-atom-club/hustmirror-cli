source_config() {
	hustmirror_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hustmirror"
	hustmirror_config="${hustmirror_config_dir}/hustmirror.conf"
	if [ -f "${hustmirror_config}" ]; then
		. "${hustmirror_config}" || {
			print_error "Failed to read configuration file: ${hustmirror_config}"
			return 1
		}
	else
		return 1
	fi
	unset _flag
	for edomain in $domains; do
		if [ "$domain" = "$edomain" ]; then
			_flag=1
		fi
	done
	if [ -z "$_flag" ]; then
		print_error "Domains has been update, your configuration file need regenerate."
		set_default_domain $domains
		return 1
	fi
}

save_config() {
	hustmirror_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hustmirror"
	hustmirror_config="${hustmirror_config_dir}/hustmirror.conf"
	mkdir -p "${hustmirror_config_dir}"
	cat <<EOF >"${hustmirror_config}"
# ${gen_tag}
domain="${domain}"
http="${http}"
EOF
}

regist_config() {
	print_warning "No configuration file found."
	if ! is_tty; then
		return 0
	fi
	if confirm_y "Do you want to autogenerate a default configuration file?"; then
		save_config
	else
		select_from_menu "Choose your prefer domain" $domains
		domain=$result
		http=https
		confirm_y "Do you want to use https rather than http?" ||
			http=http
		confirm_y "Do you want to save the configuration?" &&
			save_config
	fi
}

load_config() {
	print_status "Reading configuration file..."
	source_config || regist_config
	[ -n "$HM_HTTP" ] && http=$HM_HTTP
	[ -n "$HM_DOMAIN" ] && domain=$HM_DOMAIN
	true
}

# $1 disable output when is not zero string
set_mirror_list() {
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

	# direct return to disable output
	if [ -n "$1" ]; then return 0; fi

	if [ -z "$ready_to_install" ] && [ -z "$unsure_to_install" ]; then
		print_warning "No software is ready to install."
		print_supported
		confirm "Do you want to continue to use other function?" || exit 0
	fi

	if [ -n "$ready_to_install" ]; then
		print_info "The following software(s) are available to install:"
		echo "   $ready_to_install"
	fi

	if [ -n "$unsure_to_install" ]; then
		print_info "The following software(s) are not suggested to install:"
		echo "   $unsure_to_install"
	fi
}

# $1 disable output when is not zero string
set_mirror_recover_list() {
	ready_to_uninstall=""
	for software in $supported_softwares; do
		# check if the software is ready to recover
		if has_command _${software}_check && _${software}_check &&\
		   has_command _${software}_can_recover && _${software}_can_recover
		then
			ready_to_uninstall="$ready_to_uninstall ${software}"
		fi
	done

	if [ -z "$ready_to_uninstall" ]; then
		print_warning "No software is ready to recover."
		confirm "Do you want to continue to use other function?" || exit 0
	fi

	if [ -n "$1" ]; then return 0; fi

	if [ -n "$ready_to_uninstall" ]; then
		print_info "The following software(s) are ready to recover:"
		echo "   $ready_to_uninstall"
	fi
}

# install hust-mirror
install() {
	install_path="/usr/local/bin"
	if ! is_root; then
		print_warning "Install hust-mirror to /usr/local/bin need root permission."
	fi
	install_target="$install_path/hustmirror"
	set_sudo
	if [ ! -d "$install_path" ]; then
		print_status "Creating directory: $install_path"
		$sudo mkdir -p "$install_path"
	fi
	has_command curl || {
		print_error "curl is required."
		exit 1
	}
	print_status "Downloading latest hust-mirror..."
	$sudo curl -sSfL "${http}://${domain}/get" -o "$install_target" || {
		print_error "Failed to download hust-mirror."
		exit 1
	}
	$sudo chmod +x "$install_target"
	print_success "Successfully install hust-mirror."
	has_command hustmirror || print_warning "It seems /usr/local/bin is not in your path, try to add it to your PATH in ~/.bashrc or ~/.zshrc."
	print_success "Now, you can use \`hustmirror\` in your command line"
}

# $1 software to recover
recover() {
	software=$1
	if has_command _${software}_check && ! _${software}_check; then
		print_error "${software} is suitable here."
		return
	fi

	if has_command _${software}_can_recover && _${software}_can_recover; then
		print_success "${software} can be recoverd."
	else
		print_error "${software} can not be recoverd."
		return 1
	fi

	if has_command _${software}_uninstall; then
		print_status "recover ${software}..."
		result=0
		_${software}_uninstall || result=$?
		if [ $result -eq 0 ]; then
			print_success "Successfully uninstalled ${software}."
		else
			print_error "Failed to uninstall ${software}."
			return 1
		fi
	else
		print_error "No uninstallation method for ${software}."
	fi
}

# $1 software to deploy
deploy() {
	software=$1

	# check if the software is ready to deploy
	if has_command _${software}_check && ! _${software}_check; then
		print_error "${software} is suitable here."
		return
	fi

	if has_command _${software}_is_deployed && _${software}_is_deployed; then
		print_error "${software} has been deployed."
		return
	fi

	if has_command _${software}_install; then
		print_status "Deploying ${software}..."
		result=0
		_${software}_install || result=$?
		if [ $result -eq 0 ]; then
			print_success "Successfully deployed ${software}."
		else
			print_error "Failed to deploy ${software}."
			return 1
		fi
	else
		print_error "No installation method for ${software}."
	fi
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
