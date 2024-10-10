_msys2_config_file="/etc/pacman.d/mirrorlist.msys"

check() {
    source_os_release
    [ "$NAME" = "Msys" ] || [ "$NAME" = "Msys2" ]
}

install() {
    config_file=$_msys2_config_file
    
    set_sudo

    $sudo cp ${config_file} ${config_file}.bak || {
        print_error "Failed to backup ${config_file}"
        return 1
    }

    new_file=$(sed -E "s|https?://([^/]+)|${http}://${domain}|" $config_file)
    {
		cat << EOF | $sudo tee ${config_file} > /dev/null
# ${gen_tag}
${new_file}
EOF
	} || {
		print_error "Failed to add mirror to ${config_file}"
		return 1
    }
    
}

is_deployed() {
    config_file=$_msys2_config_file
    result=0
    $sudo grep -q "${gen_tag}" ${config_file} || result=$?
    return $result
}

can_recover() {
    bak_file=${_msys2_config_file}.bak
    result=0
    test -f $bak_file || result=$?
    return $result
}

uninstall() {
    config_file=$_msys2_config_file
    set_sudo
    $sudo mv ${config_file}.bak ${config_file} || {
        print_error "Failed to recover ${config_file}"
        return 1
    }
}
