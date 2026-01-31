# hustmirror-cli

## Introduction

`hustmirror-cli` is a CLI posix shell script to replace system repository mirror to HUST Mirror.

## Supported Linux Distributions and Software

- [x] Alpine Linux
- [x] Anolis OS
- [x] Arch Linux
- [x] Black Arch
- [x] crates
- [x] Debian
- [x] Deepin
- [x] Kali
- [x] LinuxMint
- [x] openEuler
- [x] openKylin
- [x] pypi
- [x] Rustup
- [x] Ubuntu
- [x] Oh My Zsh
- [x] radxa-deb

If you would to request supports of new Linux distributions or software, please [submit an issue](https://github.com/hust-open-atom-club/hustmirror-cli/issues/new/choose).

## Usage

```
curl -s https://mirrors.hust.edu.cn/get | sh -s -- autodeploy
```

See details about hustmirror-cli usage in the [USAGE.md](docs/USAGE.md).

## Build

Use `GNU make` to process all files and generate them
into a single executable bash.

```shell
make
```

The output script will be placed in `./output/hustmirror-cli`

## Test

```shell
make test
```

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
