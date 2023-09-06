check() {
	source_os_release
	[ "$NAME" = "Deepin" ]
}

install() {
    config_file="/etc/apt/sources.list"
    source_os_release

    if [ -z "$VERSION_CODENAME" ]; then
        print_error "Unsupported Deepin version"
        return 1
    fi

    codename=${VERSION_CODENAME}
    set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Failed to backup ${config_file}"
		return 1
	}

	new_file=$(sed -E -e "s|https?://([^/]+)/deepin|${http}://hustmirror.cn/deepin|" -e "s|https?://([^/]+)/${codename}|${http}://hustmirror.cn/deepin/${codename}|" $config_file)
	{
		cat << EOF | $sudo tee ${config_file} > /dev/null
# ${gen_tag}
${new_file}
EOF
	} || {
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
	config_file="/etc/apt/sources.list"
	set_sudo
	$sudo mv ${config_file}.bak ${config_file} || {
		print_error "Failed to recover ${config_file}"
		return 1
	}
}

is_deployed() {
	config_file="/etc/apt/sources.list"
	result=0
	$sudo grep -q "${gen_tag}" ${config_file} || result=$?
	return $result
}

can_recover() {
	bak_file="/etc/apt/sources.list.bak"
	result=0
	test -f $bak_file || result=$?
	return $result
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
