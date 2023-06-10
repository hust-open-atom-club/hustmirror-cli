check() {
	source_os_release
	result=0
	[ "$NAME" = "Ubuntu" ] || result=$?
	return $result
}

install() {
	config_file="/etc/apt/sources.list"
	source_os_release
	codename=${VERSION_CODENAME}
	set_sudo

	$sudo cp ${config_file} ${config_file}.bak
	$sudo sh -e -c "
		echo "\""# ${gen_tag}"\"" > ${config_file}
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
