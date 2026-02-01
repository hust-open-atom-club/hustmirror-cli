# Auto-generated script for RadxaOS
# Generated from: radxa-deb.md
# Mirror ID: radxaos

check() {
	has_command rsetup
}

_radxaos_install_1() {
	# Execute commands
	set_sudo

	# Execute commands
	$sudo sed -i "s|https://radxa-repo.github.io|$http://$domain/radxa-deb|g" /etc/apt/sources.list.d/*radxa*.list
	$sudo apt-get update

	return 0
}

install() {

	_radxaos_install_1 || return 1
	print_success "Mirror configuration updated successfully"
}

uninstall() {
	# Recover from backup files and execute recovery commands
	print_info "Starting recovery process..."


	# Execute recovery commands
	sed -i "s|$http://$domain/radxa-deb|https://radxa-repo.github.io|g" /etc/apt/sources.list.d/*radxa*.list 2>/dev/null || true
	apt-get update 2>/dev/null || true

	print_success "Recovery completed"
}
