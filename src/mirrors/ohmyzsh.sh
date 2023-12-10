check() {
	has_git || return 1
	git -C "${HOME}/.oh-my-zsh" remote -v >/dev/null 2>&1
}

install() {
	git -C $ZSH remote set-url origin ${http}://${domain}/git/ohmyzsh.git
	print_success "oh-my-zsh repo mirror has been set."
}

uninstall() {
	print_info "Recover oh-my-zsh mirror to official repo."
	git -C $ZSH remote set-url origin "https://github.com/ohmyzsh/ohmyzsh.git"
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
