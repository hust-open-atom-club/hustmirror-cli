# Usage

The command-line tool [hustmirror-cli](https://gitee.com/dzm91_hust/hustmirror-cli.git)  is a small utility that helps you quickly switch software sources.

It has the following features:
- One-click replacement of software sources
- Restoration of replaced software sources
- Online updates

<!-- The supported software/systems are indicated using in the main page list.

You can select your requirements from the hyperlinks below to get started quickly. -->

> [!NOTE]
> About Bash and POSIX Shell
> This command-line tool is written in POSIX shell-compatible syntax.
> The declared interpreter is `sh` from the `PATH`, and it has been tested in both the dash and bash interpreters.
>
> Bash and POSIX Shell mentioned in this document are shell environments for running and downloading online.
> 
> When using it online, since the POSIX Shell method uses pipes that occupy stdin and cannot receive user input, it is recommended to use the Bash method.

## Automatic Deployment

The tool detects whether there are deployable systems/software sources. If deployable sources are found, it proceeds with automatic deployment.

Add `-y` option to skip confirmation, using default settings.

```sh
hustmirror-cli autodeploy # or use 'ad'
```

## Running in Interactive Mode

```sh
hustmirror-cli -i
```

## Restore origin configurations

```sh
hustmirror-cli recover
```

## Installing / Updating

After installing the tool via a command, you can use the `hustmirror-cli` command to replace/restore mirror sources at any time.
This command can also be used for manual online updates of the installed tool.

```sh
hustmirror-cli install
```

## Getting Detailed Help

Besides above, this cli tool support other features
such as deploy/recover specific softwares.

To view the basic help for the tool, you can use:

```sh
hustmirror-cli help
```

For subcommands or specific topics like the `deploy` command, you can use:

```sh
hustmirror-cli help deploy
```
