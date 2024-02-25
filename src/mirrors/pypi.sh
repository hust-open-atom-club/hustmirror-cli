_synonyms_python="pypi"
_synonyms_pip="pypi"
_synonyms_pdm="pypi"

_pypi_python="python"
_pypi_backup_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hustmirror/backup"
_pypi_backup_pip="${_pypi_backup_dir}/pip.bak"
_pypi_backup_pdm="${_pypi_backup_dir}/pdm.bak"

_pypi_has_pip=""
_pypi_has_pdm=""

_pypi_isdeployed_pip=""
_pypi_isdeployed_pdm=""

_pypi_set_python() {
	if is_windows; then
		if ! has_command "python"; then
			_pypi_python=$(reg query HKCU\\Software\\Python //s //f ExecutablePath //e |
				grep ExecutablePath | head -n 1 | tr -s " " | cut -f 4 -d " ")
		fi
	fi
}

check() {
	_pypi_set_python
	has_command "$_pypi_python" && "$_pypi_python" -m pip --version >/dev/null 2>&1 && _pypi_has_pip=1
	has_command "$_pypi_python" && pdm --version >/dev/null 2>&1 && _pypi_has_pdm=1

	[ -n "$_pypi_has_pip" ] || [ -n "$_pypi_has_pdm" ]
}

is_deployed() {
	if [ -n "$_pypi_has_pip" ] &&
		$_pypi_python -m pip config get global.index-url 2>/dev/null | grep -qE "$domain"; then
		_pypi_isdeployed_pip=1
	fi
	if [ -n "$_pypi_has_pdm" ] &&
		pdm config pypi.url 2>/dev/null | grep -qE "$domain"; then
		_pypi_isdeployed_pdm=1
	fi
	[ -n "$_pypi_isdeployed_pip" ] && [ -n "$_pypi_isdeployed_pdm" ]
}

can_recover() {
	[ -f "$_pypi_backup_pip" ] || [ -f "$_pypi_backup_pdm" ]
}

install() {
	mkdir -p "$_pypi_backup_dir"
	if [ -n "$_pypi_has_pip" ]; then
		$_pypi_python -m pip config get global.index-url 2>/dev/null >"$_pypi_backup_pip"
		$_pypi_python -m pip config set global.index-url "${http}://${domain}/pypi/web/simple/"
		print_success "pip mirror has been set."
	fi
	if [ -n "$_pypi_has_pdm" ]; then
		pdm config pypi.url 2>/dev/null >"$_pypi_backup_pdm"
		pdm config pypi.url "${http}://${domain}/pypi/web/simple/"
		print_success "pdm mirror has been set."
	fi
}

uninstall() {
	if [ -n "$_pypi_has_pip" ]; then
		last_url=$(cat "$_pypi_backup_pip")
		if [ -z "$last_url" ]; then
			$_pypi_python -m pip config unset global.index-url
		else
			$_pypi_python -m pip config set global.index-url "$last_url"
		fi
		print_success "pip mirror has been recovered."
	fi
	if [ -n "$_pypi_has_pdm" ]; then
		last_url=$(cat "$_pypi_backup_pdm")
		if [ -z "$last_url" ]; then
			pdm config -d pypi.url
		else
			pdm config pypi.url "$last_url"
		fi
		print_success "pdm mirror has been recovered."
	fi
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
