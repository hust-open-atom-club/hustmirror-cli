cli_main() {
	# parse arguments


	# install
	for software in $install_things; do
		deploy $software || confirm "Do you want to continue?" || exit 1
	done
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
