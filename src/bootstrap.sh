# bootstrap
print_logo
# parse arguments
case "$1" in
	'') # no arguments
		display_help $@
		exit 0
		;;
	-V | --version)
		exit 0
		;;
	-h | --help | help) # print help
		shift 1
		display_help $@
		exit 0
		;;
	-i) # Enter interact mode
		load_config
		interact_main
		;;
	*)  # Pass arguments to cli
		load_config
		cli_main $@
esac
# vim: set filetype=sh ts=4 sw=4 noexpandtab:
