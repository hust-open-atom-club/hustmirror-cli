_anolis_config_dir="/etc/yum.repos.d"

check() {
	source_os_release
	[ "$NAME" = "Anolis OS" ]
}

install() {
	set_sudo

	for config_file in ${_anolis_config_dir}/*.repo; do
		[ -f "$config_file" ] || continue
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
	done
}

is_deployed() {

	for config_file in ${_anolis_config_dir}/*.repo; do
		[ -f "$config_file" ] || continue
		if $sudo grep -q "${gen_tag}" "${config_file}"; then
			return 0
		fi
	done

	return 1
}

can_recover() {

	for config_file in ${_anolis_config_dir}/*.repo; do
		[ -f "$config_file" ] || continue
		if ! test -f "${config_file}.bak"; then
			return 1
		fi
	done

	return 0
}

uninstall() {
	set_sudo

	for config_file in ${_anolis_config_dir}/*.repo; do
		[ -f "$config_file" ] || continue
		$sudo mv ${config_file}.bak ${config_file} || {
			print_error "Failed to recover ${config_file}"
			return 1
		}
	done

	return 0
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
