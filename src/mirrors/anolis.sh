_anolis_configs=()

_anolis_get_configs() {
    local folder="/etc/yum.repos.d"

    for file in "$folder"/*.repo; do
        if [ -f "$file" ]; then
        _anolis_configs+=("$file")
        fi
    done
}

check() {
	source_os_release
	[ "$NAME" = "Anolis OS" ]
}

install() {
	set_sudo

    _anolis_configs=()
    _anolis_get_configs

    for config_file in "${_anolis_configs[@]}"; do
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

    _anolis_configs=()
    _anolis_get_configs

    for config_file in "${_anolis_configs[@]}"; do
        if $sudo grep -q "${gen_tag}" "${config_file}"; then
            return 0
        fi
    done

    return 1
}

can_recover() {
    _anolis_configs=()
    _anolis_get_configs

    for config_file in "${_anolis_configs[@]}"; do
        if ! test -f "${config_file}.bak"; then
            return 1
        fi
    done

    return 0
}

uninstall() {
	set_sudo
    
    _anolis_configs=()
    _anolis_get_configs

    for config_file in "${_anolis_configs[@]}"; do
        $sudo mv ${config_file}.bak ${config_file} || {
            print_error "Failed to recover ${config_file}"
            return 1
        }
    done

    return 0
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
