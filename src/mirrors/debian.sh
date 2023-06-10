install() {
	codename=${VERSION_CODENAME}
	echo "# Genreated by hustmirror-cli" > ${config_file}
	echo "deb https://hustmirror.cn/debian/ ${codename} main contrib non-free non-free-firmware" >> ${config_file}
	echo "# deb-src https://hustmirror.cn/debian/ ${codename} main contrib non-free non-free-firmware" >> ${config_file}
	echo "deb https://hustmirror.cn/debian/ ${codename}-updates main contrib non-free non-free-firmware" >> ${config_file}
	echo "# deb-src https://hustmirror.cn/debian/ ${codename}-updates main contrib non-free non-free-firmware" >> $config_file
	echo >> $config_file
	# Never change security software repository due to security concern
	echo "deb http://security.debian.org/debian-security ${codename}-security main contrib non-free non-free-firmware" >> ${config_file}
	echo "# deb http://security.debian.org/debian-security ${codename}-security main contrib non-free non-free-firmware" >> $config_file
	echo "Please execute the following commands:"
	echo "sudo mv /etc/apt/sources.list /etc/apt/sources.list.save"
	echo "sudo mv ${config_file} /etc/apt/sources.list"
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
