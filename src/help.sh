# help bootstrap
if [ "$0" = "sh" ] || [ "$0" = "bash" ]; then
	program="hust-mirror.sh"
else
	program=$(basename "$0")
fi

# help text, define _help_(topic) variable
_help_basic="A CLI posix shell script to generate a configuration file for software
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
   autorecover                Recover deployed and recoverable configuration file
   install                    Install this script to user's local bin

Commands alias:
   h                          help
   d                          deploy
   ad                         autodeploy
   r                          recover
   ar                         autorecover
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

"

_help_help="Get help of a command or a target topic.

Usage: $program help [command|topic]
       $program h [command|topic] (alias)

Examples:
- Get help of a command
   $program help deploy
- Get help of a topic
   $program help debian

"

_help_deploy="
Deploy the configuration file.

Usage: $program deploy [targets...]
       $program d [targets...] (alias)

Examples:
- Deploy the configuration file for openeuler and pypi
   $program deploy openeuler pypi

"

_help_autodeploy="
Check the system and deploy suggested configuration file.

Usage: $program autodeploy
       $program ad (alias)

Options: (optional)
   -y                         Answer default option to all questions

"

_help_recover="Recover the configuration file.

Usage: $program recover [targets...]
       $program r [targets...] (alias)

"

_help_install="Install (Update) this script online to user's local bin.

Usage: $program install
       $program i | u | update (alias)

Note: This command will install the script to ~/.local/bin, and add it to
      PATH in ~/.bashrc or ~/.zshrc.

"

_help_autorecover="Recover deployed and recoverable configuration file.

Usage: $program autorecover
       $program ar (alias)

Note: This command will only recover the configuration file that can be recovered,
      if you don't use this tool to deploy or have deployed some configurations not 
      support to recover, you can't recover it.

"

_help_d=${_help_deploy}
_help_ad=${_help_autodeploy}
_help_r=${_help_recover}
_help_ar=${_help_autorecover}
_help_i=${_help_install}
_help_u=${_help_install}
_help_h=${_help_help}
_help_update=${_help_install}

_help_debian="Debian mirror configuration.

Environments:
   DEBIAN_USE_SID            Use unstable instead of testing.

"

display_help() {
	echo

	if [ -z "$1" ]; then
		r_echo "$_help_basic"
		return
	fi

	eval help_text=\"\${_help_${1}}\"

	if [ -z "$help_text" ]; then
		print_error "No help information for $1"
	else
		r_echo "$help_text"
	fi
}

# expand tab for help text
# code style is noexpandtab
# vim: set filetype=sh ts=4 sw=4 expandtab:
