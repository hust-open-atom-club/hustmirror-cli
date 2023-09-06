# help bootstrap
if [ "$0" = "sh" ] || [ "$0" = "bash" ]; then
	program="hust-mirror.sh"
else
	program=$(basename "$0")
fi

# help text, define _(topic)_help variable
_basic_help=$(cat <<EOF
A CLI posix shell script to generate a configuration file for software
repository on different distributions.

Usage: $program [options...]
       $program [command] [targets...]

Options:
   -h, --help                 Display this help message
   -i                         Enter interact mode

Commands: (use \`$program help [command]\` to get more information)
   help                       Display help message
   deploy                     Deploy the configuration file
   autodeploy                 Deploy suggested configuration file
   recover                    Recover the configuration file
   install                    Install this script to user's local bin

Commands alias:
   h                          help
   d                          deploy
   ad                         autodeploy
   r                          recover
   i|u|update                 install

Examples:
- Enter interact mode
   $program -i
- Deploy some configuration file
   $program deploy openeuler
- Get command help
   $program help ad

Environments: (optional)
   HM_HTTP                    protoal (http/https), default is http
   HM_DOMAIN                  domain name

EOF
)

_help_help=$(cat <<EOF
Get help of a command or a target topic.

Usage: $program help [command|topic]
       $program h [command|topic] (alias)

Examples:
- Get help of a command
   $program help deploy
- Get help of a topic
   $program help debian

EOF
)

_deploy_help=$(cat <<EOF
Deploy the configuration file.

Usage: $program deploy [targets...]
       $program d [targets...] (alias)

Examples:
- Deploy the configuration file for openeuler and pypi
   $program deploy openeuler pypi

EOF
)

_autodeploy_help=$(cat <<EOF
Check the system and deploy suggested configuration file.

Usage: $program autodeploy
       $program ad (alias)

EOF
)

_recover_help=$(cat <<EOF
Recover the configuration file.

Usage: $program recover [targets...]
       $program r [targets...] (alias)

EOF
)

_install_help=$(cat <<EOF
Install (Update) this script online to user's local bin.

Usage: $program install
       $program i | u | update (alias)

Note: This command will install the script to ~/.local/bin, and add it to
      PATH in ~/.bashrc or ~/.zshrc.

EOF
)

_d_help=${_deploy_help}
_ad_help=${_autodeploy_help}
_r_help=${_recover_help}
_i_help=${_install_help}
_u_help=${_install_help}
_h_help=${_help_help}
_update_help=${_install_help}


_debian_help=$(cat <<EOF
Debian mirror configuration.

Environments:
   DEBIAN_USE_SID            Use unstable instead of testing.

EOF
)


display_help() {
    echo

	if [ -z "$1" ] || [ "$1" = "basic" ]; then
		r_echo "$_basic_help"
        return
	fi

	eval help_text=\"\${_${1}_help}\"

	if [ -z "$help_text" ]; then
		print_error "No help information for $1"
	else
		r_echo "$help_text"
	fi
}

# expand tab for help text
# code style is noexpandtab
# vim: set filetype=sh ts=4 sw=4 expandtab:
