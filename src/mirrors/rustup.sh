_rustup_get_shell_rc() {
	sh=$(basename "$SHELL")
	case "$sh" in
		bash)
			_rustup_shell_rc="$HOME/.bashrc"
			;;
		zsh)
			_rustup_shell_rc="$HOME/.zshrc"
			;;
		fish)
			_rustup_shell_rc=""
			print_error "fish is not supported."
			;;
		*)
			_rustup_shell_rc=""
			;;
	esac
}

_rustup_gen_tag="${gen_tag}::rustup"

check() {
	has_command rustup
}

is_deployed() {
	_rustup_get_shell_rc
	if [ -z "$_rustup_shell_rc" ]; then
		print_error "Can not find shell rc file."
		return 1
	fi
	grep -qE "${_rustup_gen_tag}" "$_rustup_shell_rc"
}


install() {
	_rustup_get_shell_rc
	if [ -z "$_rustup_shell_rc" ]; then
		print_error "Can not find shell rc file."
		return 1
	fi
	echo "export RUSTUP_DIST_SERVER=${http}://${domain}/rustup # ${_rustup_gen_tag}"  \
		>> "$_rustup_shell_rc"
	echo "export RUSTUP_UPDATE_ROOT=${http}://${domain}/rustup/rustup # ${_rustup_gen_tag}" \
		>> "$_rustup_shell_rc"
	print_success "rustup mirror will take effect next time shell start."
}

uninstall() {
	_rustup_get_shell_rc
	if [ -z "$_rustup_shell_rc" ]; then
		print_error "Can not find shell rc file."
		return 1
	fi
	sed -i "/${_rustup_gen_tag}/d" "$_rustup_shell_rc"
	print_success "rustup mirror has been unset."
}


# vim: set filetype=sh ts=4 sw=4 noexpandtab:
