install() {
	config_file="/etc/apt/sources.list"
	codename=${VERSION_CODENAME}
	source_os_release
	set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Failed to backup ${config_file}"
		return 1
	}

	$sudo sh -e -c "cat << EOF > ${config_file}
# ${gen_tag}
deb ${http}://${domain}/debian ${codename} main contrib non-free
# deb-src ${http}://${domain}/debian ${codename} main contrib non-free

deb ${http}://${domain}/debian ${codename}-updates main contrib non-free
# deb-src ${http}://${domain}/debian ${codename}-updates main contrib non-free

deb ${http}://${domain}/debian ${codename}-backports main contrib non-free
# deb-src ${http}://${domain}/debian ${codename}-backports main contrib non-free

deb ${http}://security.debian.org/debian-security ${codename}-security main contrib non-free
# deb-src ${http}://security.debian.org/debian-security ${codename}-security main contrib non-free

EOF" || {
		print_error "Failed to add mirror to ${config_file}"
		return 1
	}
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
