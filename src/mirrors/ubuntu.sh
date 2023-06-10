check() {
	source_os_release
	result=0
	[ "$NAME" = "Ubuntu" ] || result=$?
	return $result
}

install() {
	config_file="/etc/apt/sources.list"

	test -e /etc/os-release && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
	. "${os_release}"
	codename=${VERSION_CODENAME}

	sudo=''

	if [ ! is_root ] ; then
		has_sudo || return 1
		sudo='sudo'
	fi


	$sudo cp ${config_file} ${config_file}.bak
	$sudo sh -c "
		echo "\""# Genreated by hustmirror-cli"\"" > ${config_file}
		echo "\""deb https://hustmirror.cn/ubuntu/ ${codename} main universe restricted multiverse"\"" >> ${config_file}
		echo "\""# deb-src https://hustmirror.cn/ubuntu/ ${codename} main universe restricted multiverse"\"" >> ${config_file}
		echo "\""deb https://hustmirror.cn/ubuntu/ ${codename}-updates main universe restricted multiverse"\"" >> ${config_file}
		echo "\""# deb-src https://hustmirror.cn/ubuntu/ ${codename}-updates main universe restricted multiverse"\"" >> $config_file
		echo >> ${config_file}
		# Never change security software repository due to security concern
		echo "\""deb http://security.ubuntu.com/ubuntu ${codename}-security main universe restricted multiverse"\"" >> ${config_file}
		echo "\""# deb-src http://security.ubuntu.com/ubuntu ${codename}-security main universe restricted multiverse"\"" >> $config_file
	"
}

uninstall() {
	:
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
