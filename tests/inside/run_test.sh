# before source this file, you should set the following variables:
# 1. config_file	
# 2. update_command
# 3. recover_item
# 4. new_config_file (optional)

set -e

[[ -z $new_config_file ]] && new_config_file=$config_file

template="\n*------------------*\n %s\n*------------------*\n\n"

print_title() {
  printf "$template" "$*"
}

# close stdin and save file
exec 0<&-
cat $config_file > origin.txt || true

print_title "1. Running deploy"
HM_HTTP=http HM_TEST_MODE=y /hustmirror/hustmirror-cli autodeploy
cat $new_config_file > new.txt || true

print_title "2. Running updates"
eval $update_command

print_title "3. Running recover"
HM_HTTP=http HM_TEST_MODE=y /hustmirror/hustmirror-cli recover $recover_item
cat $config_file > recover.txt || true

print_title "4. Diff files"
# no diff and cmp, use sha1sum to compare
a=$(sha1sum origin.txt | cut -d ' ' -f 1)
b=$(sha1sum recover.txt | cut -d ' ' -f 1)
echo "origin.txt sum: $a"
echo "recover.txt sum: $b"
test "$a" = "$b" 

print_title "5. Running updates"
eval $update_command

# All is ok and create pass file
touch pass
