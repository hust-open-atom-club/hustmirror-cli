_linuxmint_config_file="/etc/apt/sources.list.d/official-package-repositories.list"

check() {
	source_os_release
	[ "$NAME" = "Linux Mint" ]
}

install() {
    config_file=$_linuxmint_config_file
    source_os_release

    codename=${VERSION_CODENAME}
	ubuntu_codename=${UBUNTU_CODENAME}
    set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Failed to backup ${config_file}"
		return 1
	}

	# Replace linuxmint source, remove lines related to Ubuntu at the same time
    new_file=$(sed -E -e "s|https?://([^/]+)/linuxmint|${http}://${domain}/linuxmint|;s|https?://packages\.linuxmint\.com|${http}://${domain}/linuxmint|;/ubuntu/d" $config_file)
	{
		cat << EOF | $sudo tee ${config_file} > /dev/null
# ${gen_tag}
${new_file}
EOF
	} || {
		print_error "Failed to add mirror to ${config_file}"
		return 1
	}

	# Append Ubuntu source to the end of the file
	print_info "Adding Ubuntu mirror to ${config_file}:"
	secure_url="${http}://${domain}/ubuntu/"
	confirm_y "Use official secure source? (Strongly recommended)" && \
		secure_url="http://security.ubuntu.com/ubuntu/"

	propoesd_prefix="# "
	confirm "Use proposed source?" && \
		propoesd_prefix=""

	src_prefix="# "
	confirm "Use source code?" && \
		src_prefix=""

	$sudo sh -e -c "cat <<EOF >> ${config_file}
# ${gen_tag}
deb ${http}://${domain}/ubuntu/ ${ubuntu_codename} main restricted universe multiverse
${src_prefix}deb-src ${http}://${domain}/ubuntu/ ${ubuntu_codename} main restricted universe multiverse
deb ${http}://${domain}/ubuntu/ ${ubuntu_codename}-updates main restricted universe multiverse
${src_prefix}deb-src ${http}://${domain}/ubuntu/ ${ubuntu_codename}-updates main restricted universe multiverse
deb ${secure_url} ${ubuntu_codename}-security main restricted universe multiverse
${src_prefix}deb-src ${secure_url} ${ubuntu_codename}-security main restricted universe multiverse

${propoesd_prefix}deb ${http}://${domain}/ubuntu/ ${ubuntu_codename}-proposed main restricted universe multiverse
${propoesd_prefix}deb-src ${http}://${domain}/ubuntu/ ${ubuntu_codename}-proposed main restricted universe multiverse
EOF" || {
		print_error "Failed to add Ubuntu mirror to ${config_file}"
		return 1
	}

    confirm_y "Do you want to apt update?" && {
		$sudo apt update || {
			print_error "apt update failed"
			return 1
		}
	}

	true
}

uninstall() {
    config_file=$_linuxmint_config_file
    
	set_sudo
	$sudo mv ${config_file}.bak ${config_file} || {
		print_error "Failed to recover ${config_file}"
		return 1
	}
}

is_deployed() {
    config_file=$_linuxmint_config_file
	result=0
	$sudo grep -q "${gen_tag}" ${config_file} || result=$?
	return $result
}

can_recover() {
	bak_file=${_linuxmint_config_file}.bak
	result=0
	test -f $bak_file || result=$?
	return $result
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
