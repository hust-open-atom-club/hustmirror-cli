# bootstrap
print_logo
load_config
# parse arguments
case "$1" in
	-h | --help) # print help
		display_help
		exit 0
		;;
	-i | '') # Enter interact mode
		interact_main
		;;
	*)  # Pass arguments to cli
		cli_main $@
esac
# vim: set filetype=sh ts=4 sw=4 noexpandtab:
