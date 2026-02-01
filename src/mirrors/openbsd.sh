# OpenBSD mirror configuration script
# Mirror ID: openbsd

check() {
	[ "$(uname -s)" = "OpenBSD" ]
}

_openbsd_install_1() {
	# 一键替换 OpenBSD 软件源（/etc/installurl）
	set_sudo

	if [ -f /etc/installurl ]; then
		mkdir -p ${_backup_dir} || {
			print_error "Failed to create backup directory"
			return 1
		}
		[ -f ${_backup_dir}/openbsd__etc_installurl.bak ] || $sudo cp /etc/installurl ${_backup_dir}/openbsd__etc_installurl.bak || {
			print_error "Backup /etc/installurl failed"
			return 1
		}
		printf '%s\n' "$http://$domain/OpenBSD" | $sudo tee /etc/installurl >/dev/null || {
			print_error "Failed to update /etc/installurl"
			return 1
		}
	else
		print_warning "File /etc/installurl does not exist"
	fi

	return 0
}

install() {

	_openbsd_install_1 || return 1
	print_success "Mirror configuration updated successfully"
}

uninstall() {
	# Recover from backup files and execute recovery commands
	print_info "Starting recovery process..."

	# Restore files from backup
	if [ -f ${_backup_dir}/openbsd__etc_installurl.bak ]; then
		set_sudo
		$sudo cp "${_backup_dir}/openbsd__etc_installurl.bak" /etc/installurl 2>/dev/null || true
		print_info "Restored /etc/installurl"
	fi

	print_success "Recovery completed"
}

can_recover() {
	# Check if any backup files exist
	[ -f ${_backup_dir}/openbsd__etc_installurl.bak ]
}

is_deployed() {
	# Check if any replaced file contains domain variable
	[ -f /etc/installurl ] && grep -q "$domain" /etc/installurl 2>/dev/null && return 0
	return 1
}
