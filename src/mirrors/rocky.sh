check() {
	source_os_release
	[ "$NAME" = "Rocky Linux" ]
}

install() {
	source_os_release
	set_sudo

	config_pattern="/etc/yum.repos.d/[Rr]ocky*.repo"
	
	print_info "Changing Rocky Linux repositories to ${domain}..."
	
	for file in $config_pattern; do
		[ -f "$file" ] || continue
		$sudo cp "$file" "${file}.bak" || {
			print_error "Failed to backup $file"
			return 1
		}
	done

	$sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
		-e 's|^#*baseurl=http://dl.rockylinux.org/\$contentdir/\$releasever|baseurl='"${http}://${domain}/rocky/\$releasever"'|g' \
		-e 's|^#*baseurl=https://dl.rockylinux.org/\$contentdir/\$releasever|baseurl='"${http}://${domain}/rocky/\$releasever"'|g' \
		-i \
		$config_pattern || {
		print_error "Failed to modify Rocky repos"
		return 1
	}

	for file in $config_pattern; do
		[ -f "$file" ] || continue
		$sudo sed -i "1i# ${gen_tag}" "$file"
	done

	print_success "Rocky Linux repositories changed to ${domain}"

	confirm_y "Do you want to clean cache and makecache?" && {
		$sudo dnf clean all 2>/dev/null || $sudo yum clean all
		$sudo rm -rf /var/cache/dnf /var/cache/yum
		$sudo dnf makecache 2>/dev/null || $sudo yum makecache || {
			print_error "makecache failed"
			return 1
		}
		print_success "Cache updated successfully"
	}

	true
}

uninstall() {
	config_pattern="/etc/yum.repos.d/[Rr]ocky*.repo"
	set_sudo
	
	print_info "Recovering Rocky Linux repositories..."
	
	recovered=0
	for file in $config_pattern; do
		bak_file="${file}.bak"
		if [ -f "$bak_file" ]; then
			$sudo mv "$bak_file" "$file" || {
				print_error "Failed to recover $file"
				return 1
			}
			recovered=1
		fi
	done

	if [ $recovered -eq 1 ]; then
		print_success "Rocky Linux repositories recovered"
	else
		print_warning "No Rocky Linux backup files found"
	fi

	true
}

is_deployed() {
	config_file="/etc/yum.repos.d/rocky.repo"
	[ ! -f "$config_file" ] && config_file="/etc/yum.repos.d/Rocky.repo"
	
	[ ! -f "$config_file" ] && return 1
	
	result=0
	grep -q "${gen_tag}" "$config_file" 2>/dev/null || result=$?
	return $result
}

can_recover() {
	for file in /etc/yum.repos.d/[Rr]ocky*.repo.bak; do
		[ -f "$file" ] && return 0
	done
	return 1
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
