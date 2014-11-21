# My ZSH configuration

Install with:

    git clone --recursive https://github.com/thebendavis/myzsh.git ~/.myzsh

    ln -s ~/.myzsh/zshenv ~/.zshenv
    ln -s ~/.myzsh/zshrc ~/.zshrc

If you install to somewhere other than `~/.myzsh`, adjust the `myzsh` value in `zshenv` accordingly.


## Local Settings

Create a file `~/.zlocal` for local, machine-specific (untracked) customizations and it will be sourced at the end of `~/.zshrc`.

Example:

    path=(
        $path
        $HOME/z/local/bin
    )

    q="/long/path/goes/here"

    eval $(keychain --eval --quiet ~/.ssh/id_rsa)


## Theme

The prompt theme displays a number of indicators, when relevant.

[![prompt theme screenshot](https://github.com/thebendavis/myzsh/raw/master/docs/prompt-theme-screenshot.png)](https://github.com/thebendavis/myzsh/raw/master/docs/prompt-theme-screenshot.png)
