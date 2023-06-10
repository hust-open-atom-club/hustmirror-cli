install() {
  get_input "What is the path to do you want to clone linux.git? [`pwd`]" "`pwd`"

  clone_dst=$(realpath -m $input)
  has_git || {
    print_error "git is not installed"
    return 1
  }

  mkdir -p "$clone_dst"

  git clone "${http}://${domain}/git/linux.git" "${clone_dst}" || {
    print_error "git clone failed"
    return 1
  }

  print_success "git clone success, you can find linux source in ${clone_dst}"
}
