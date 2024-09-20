check() {
	source_os_release
	[ "$NAME" = "Ubuntu" ]
}

_ubuntu_set_config_file() {
	config_file="/etc/apt/sources.list.d/ubuntu.sources"
	if ! [ -f $config_file ]; then # rule for ubuntu before 24.04
		config_file="/etc/apt/sources.list"
	fi
}

install() {
	_ubuntu_set_config_file
	source_os_release
	codename=${VERSION_CODENAME}
	set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Backup ${config_file} failed"
		return 1
	}

	secure_url="${http}://${domain}/ubuntu/"
	confirm_y "Use official secure source? (Strongly recommended)" && \
		secure_url="http://security.ubuntu.com/ubuntu/"

	propoesd_prefix="# "
	confirm "Use proposed source?" && \
		propoesd_prefix=""

	src_prefix="# "
	confirm "Use source code?" && \
		src_prefix=""

	# 如果 config_file == /etc/apt/sources.list.d/ubuntu.sources
	if [ "$config_file" = "/etc/apt/sources.list.d/ubuntu.sources" ]; then
		$sudo sh -e -c  "cat <<EOF > ${config_file}
# ${gen_tag}
Types: deb
URIs: ${http}://${domain}/ubuntu/
Suites: ${codename} ${codename}-updates ${codename}-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

${src_prefix}Types: deb-src
${src_prefix}URIs: ${http}://${domain}/ubuntu/
${src_prefix}Suites: ${codename} ${codename}-updates ${codename}-backports
${src_prefix}Components: main universe restricted multiverse
${src_prefix}Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: ${secure_url}
Suites: ${codename}-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

${src_prefix}Types: deb-src
${src_prefix}URIs: ${secure_url}
${src_prefix}Suites: ${codename}-security
${src_prefix}Components: main universe restricted multiverse
${src_prefix}Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

${propoesd_prefix}Types: deb
${propoesd_prefix}URIs: ${http}://${domain}/ubuntu/
${propoesd_prefix}Suites: ${codename}-proposed
${propoesd_prefix}Components: main universe restricted multiverse
${propoesd_prefix}Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

${propoesd_prefix}Types: deb-src
${propoesd_prefix}URIs: ${http}://${domain}/ubuntu/
${propoesd_prefix}Suites: ${codename}-proposed
${propoesd_prefix}Components: main universe restricted multiverse
${propoesd_prefix}Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF"
	else
		$sudo sh -e -c  "cat <<EOF > ${config_file}
# ${gen_tag}
deb ${http}://${domain}/ubuntu/ ${codename} main restricted universe multiverse
${src_prefix}deb-src ${http}://${domain}/ubuntu/ ${codename} main restricted universe multiverse
deb ${http}://${domain}/ubuntu/ ${codename}-updates main restricted universe multiverse
${src_prefix}deb-src ${http}://${domain}/ubuntu/ ${codename}-updates main restricted universe multiverse
deb ${http}://${domain}/ubuntu/ ${codename}-backports main restricted universe multiverse
${src_prefix}deb-src ${http}://${domain}/ubuntu/ ${codename}-backports main restricted universe multiverse

deb ${secure_url} ${codename}-security main restricted universe multiverse
${src_prefix}deb-src ${secure_url} ${codename}-security main restricted universe multiverse

${propoesd_prefix}deb ${http}://${domain}/ubuntu/ ${codename}-proposed main restricted universe multiverse
${propoesd_prefix}deb-src ${http}://${domain}/ubuntu/ ${codename}-proposed main restricted universe multiverse
EOF"
	fi

	if [ $? -ne 0 ]; then
		print_error "Write ${config_file} failed"
		return 1
	fi

	confirm_y "Do you want to apt update?" && {
		$sudo apt update || {
			print_error "apt update failed"
			return 1
		}
	}

	true
}

uninstall() {
	_ubuntu_set_config_file
	set_sudo
	$sudo mv ${config_file}.bak ${config_file} || {
		print_error "Failed to recover ${config_file}"
		return 1
	}
}

is_deployed() {
	_ubuntu_set_config_file
	result=0
	$sudo grep -q "${gen_tag}" ${config_file} || result=$?
	return $result
}

can_recover() {
	_ubuntu_set_config_file
	bak_file="$config_file.bak"

	result=0
	test -f $bak_file || result=$?
	return $result
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
