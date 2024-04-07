interact_recover() {
	set_mirror_recover_list

	get_input "What do you want to uninstall?
	<softwares> for specific softwares, use space to separate multiple softwares."

	uninstall_things="$input"

	# uninstall
	for software in $uninstall_things; do
		recover $software || confirm "Do you want to continue?" || exit 1
	done
}

interact_deploy() {
	for item in $@
	do
		deploy $item || confirm "Do you want to continue?" || exit 1
	done
}

interact_main() {
	if ! is_tty; then
		print_error "Interactive mode must be run in a tty. Arguments is required to enable cli mode, try '-h' to get more information about how to use cli mode."
		exit 1
	fi

	set_mirror_list

	install_things=""
	while true; do
		input=""
		get_input "What do you want to install? [all] 
	(a)ll for ready, all! (a!) for all software(s), including unsure ones.
	<softwares> for specific softwares, use space to separate multiple softwares.
	(l)ist for forcely list all softwares, even is not supported here.
    
	Other options:
	(r)ecover for uninstall software mirror.
	(i)nstall or update hust-mirror locally
	(q)uit for exit."

		# parse input
		if [ -z "$input" ]; then
			input="all"
		fi

		case "$input" in
			a | all)
				interact_deploy $ready_to_install
				break
				;;
			a! | all!)
				interact_deploy $ready_to_install $unsure_to_install
				break
				;;
			l | list)
				print_supported
				;;
			q | quit)
				exit 0
				;;
			r | recover)
				interact_recover
				break
				;;
			i | install)
				install
				break
				;;
			*)
				interact_deploy $input
				break
				;;
		esac
	done

}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
