_crates_cargo_home="${HOME}/.cargo"

_crates_support_sparse() {
	version=$(cargo --version 2>/dev/null | cut -f 2 -d " ")
	[ -n "$version" ] && \
		[ $(echo "$version" | cut -f 1 -d ".") -ge 1 ] && \
		[ $(echo "$version" | cut -f 2 -d ".") -ge 68 ]
}

check() {
	cargo --version >/dev/null 2>&1
}

is_deployed() {
	[ -f "${_crates_cargo_home}/config.toml" ] && \
		grep -qE "${gen_tag}" "${_crates_cargo_home}/config.toml"
}

install() {
	mkdir -p "${_crates_cargo_home}"

	if [ -f "${_crates_cargo_home}/config.toml" ] || \
		[ -f "${_crates_cargo_home}/config"]; then
		confirm "You already have a config.toml file in your cargo home, do you want to continue?" || \
			return 1
		if [ -f "${_crates_cargo_home}/config" ]; then
			mv "${_crates_cargo_home}/config" "${_crates_cargo_home}/config.bak"
		else
			mv "${_crates_cargo_home}/config.toml" "${_crates_cargo_home}/config.bak"
		fi
	else
		touch "${_crates_cargo_home}/config.bak"
	fi

	if _crates_support_sparse; then
		_crates_mirror="sparse+${http}://${domain}/crates.io-index/"
	else
		_crates_mirror="${http}://${domain}/git/crates.io-index/"
	fi

	cat >"${_crates_cargo_home}/config.toml" <<EOF
# ${gen_tag}
[source.crates-io]
replace-with = 'hustmirror'

[source.hustmirror]
registry = "${_crates_mirror}"
EOF
	print_success "crates mirror has been set."
}

can_recover() {
	[ -f "${_crates_cargo_home}/config.bak" ]
}

uninstall() {
	mv "${_crates_cargo_home}/config.bak" "${_crates_cargo_home}/config"
	print_success "crates mirror has been unset."
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
