_alpine_config_file="/etc/apk/repositories"

check() {
	source_os_release
	[ "$NAME" = "Alpine Linux" ]
}

install() {
	config_file=$_alpine_config_file
	set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Failed to backup ${config_file}"
		return 1
	}

	{
		sed -i "1i # ${gen_tag}" ${config_file}
	} && {
		sed -i "s|https://dl-cdn.alpinelinux.org|${http}://${domain}|g" ${config_file} 
	} || {
			print_error "Failed to add mirror to ${config_file}"
			return 1
		}
	
}

is_deployed() {
	config_file=$_alpine_config_file
	pattern="^[^#]*${http}://${domain}/*"
	grep -qE "${pattern}" ${config_file}
}

can_recover() {
	bak_file=${_alpine_config_file}.bak
	result=0
	test -f $bak_file || result=$?
	return $result
}

uninstall() {
	config_file=$_alpine_config_file
	set_sudo
	$sudo mv ${config_file}.bak ${config_file} || {
		print_error "Failed to recover ${config_file}"
		return 1
	}
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:x
