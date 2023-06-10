
# parse arguments
while true; do
    if [ $# -eq 0 ];then
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
        *)  # No more options
            break
            ;;
    esac
done

# Refer to https://www.freedesktop.org/software/systemd/man/os-release.html
# /etc/os-release does exist in most Linux distributions, and BSD variants
test -e /etc/os-release && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
source "${os_release}"


# vim: set filetype=sh ts=4 sw=4 noexpandtab:
