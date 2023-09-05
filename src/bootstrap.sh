# parse arguments
while true; do
    if [ $# -eq 0 ]; then
		break
    fi
    case "$1" in
        -h | --help)
            display_help
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            exit 1
            ;;
		autoinstall | ai)
			;;
		install | i | deploy | d)
			;;
		remove | rm | uninstall)
			;;
        *)  # No more options
            break
            ;;
    esac
done

ready_to_install=""
ready_to_uninstall=""
unsure_to_install=""
install_things=""

print_logo




# vim: set filetype=sh ts=4 sw=4 noexpandtab:
