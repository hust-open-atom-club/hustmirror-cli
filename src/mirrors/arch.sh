check() {
	source_os_release
	result=0
	[ "$NAME" = "Arch Linux" ] || result=$?
	return $result
}

install() {
  :
}

uninstall() {
	:
}
