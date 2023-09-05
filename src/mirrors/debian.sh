check() {
	source_os_release
	[ "$NAME" = "Debian GNU/Linux" ]
}

_debian_set_config_file() {
	config_file="/etc/apt/sources.list"
	if ! [ -f $config_file ]; then # rule for docker
		old_file="/etc/apt/sources.list.d/debian.sources"
	else
		old_file=$config_file
	fi
}

install() {
	_debian_set_config_file
	source_os_release
	codename=${VERSION_CODENAME}
	echo "$PRETTY_NAME" | grep "sid" > /dev/null && {
		if [ "$HM_DEBIAN_SID" = "true" ]; then
			codename="sid"
		else
			print_warning "hustmirror cannot distinguish sid or testing"
			get_input "Please input codename (sid/testing): " "testing"
			codename="$input"
		fi
	}

	set_sudo

	if [ -f $config_file ]; then
		$sudo cp ${config_file} ${config_file}.bak || {
			print_error "Failed to backup ${config_file}"
			return 1
		}
	else
		print_warning "No ${config_file} found, creating new one"
	fi

	secure_url="${http}://${domain}/debian-security/"
	confirm_y "Use official secure source?" && \
		secure_url="${http}://security.debian.org/debian-security"

	src_prefix="# "
	confirm "Use source code?" && \
		src_prefix=""


	security_appendix='-security'
	[ "$codename" = "buster" ] && security_appendix='/updates'

	NFW=''
	if [ "$codename" = "bookworm" ] || [ "$codename" = "sid" ] || [ "$codename" = "testing" ]; then
	  NFW=' non-free-firmware'	
	fi

	if [ "$codename" = "sid" ]; then
		sid_prefix="# "
	fi


	$sudo sh -e -c "cat << EOF > ${config_file}
# ${gen_tag}
deb ${http}://${domain}/debian ${codename} main contrib non-free${NFW}
${src_prefix}deb-src ${http}://${domain}/debian ${codename} main contrib non-free${NFW}

${sid_prefix}deb ${http}://${domain}/debian ${codename}-updates main contrib non-free${NFW}
${sid_prefix}${src_prefix}deb-src ${http}://${domain}/debian ${codename}-updates main contrib non-free${NFW}

${sid_prefix}deb ${http}://${domain}/debian ${codename}-backports main contrib non-free${NFW}
${sid_prefix}${src_prefix}deb-src ${http}://${domain}/debian ${codename}-backports main contrib non-free${NFW}

${sid_prefix}deb ${secure_url} ${codename}${security_appendix} main contrib non-free${NFW}
${sid_prefix}${src_prefix}deb-src ${http}://security.debian.org/debian-security ${codename}${security_appendix} main contrib non-free${NFW}

EOF" || {
		print_error "Failed to add mirror to ${config_file}"
		return 1
	}

	confirm_y "Do you want to apt update?" && {
		$sudo apt update || {
			print_error "apt update failed"
			return 1
		}
	}

}

uninstall() {
	_debian_set_config_file
	set_sudo
	$sudo sh -c "rm ${config_file}; mv ${old_file}.bak ${old_file}" || {
		print_error "Failed to recover ${old_file}"
		return 1
	}
}

is_deployed() {
	_debian_set_config_file
	$sudo grep -q "${gen_tag}" ${config_file}
}

can_recover() {
	_debian_set_config_file
	bak_file="$old_file.bak"
	test -f $bak_file
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
