# hustmirror-cli

## Introduction
命令行工具(hustmirror-cli)是一个可以帮助你快速换源的小工具。

## Usage
```
curl -s https://hustmirror.cn/get | sh
```

## Build
Use `GNU make` to process all files and generate them
into a single executable bash.
```shell
make
```

output script will be placed in `/output/hustmirror.sh`

## Contract

### Styles
- Syntax of scripts is supposed to POSIX shell compatible.
- Use 4 character tab indent.
- We suppose that user only install `GNU coreutils` or `busybox`.
    So prerequisite check is supposed to be made when use other
    utils like `gcc` or `make`.

### Directories
- src: scripts would packaging into output scripts.
    - src/mirrors: scripts subject to mirror script contract.
    - src/main.sh.template: template shell file.
    - src/checkfile.sh: check file.
- scripts: store scripts used for packaging.

### Template
Template file supports following directives:
- `@include file`: include other files.
- `@var(shell code)`: get a string from build process.
- `@mirrors`: include all processed mirror scripts.

### Mirror script contract
All files in mirror should implement following functions.
- `check`: (optional) check if target machine is satisfied to replace mirror.
- `install`: install mirror.
- `is_deployed`: (optional) check whether is deployed.
- `can_recover`: (optional) check whether can be recovered.
- `uninstall`: (optional) recover installation.
