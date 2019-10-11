```
NAME
     viro — an environment manager

SYNOPSIS
     viro env [ls] [set name value] [get name] [rm name] [has name]
     viro path [ls] [add dir] [rm dir] [has dir]
     viro fn [new name] [edit name] [cp name new] [rm name]

DESCRIPTION
     viro allows you to swiftly manage environment variables and create shell functions by
     providing a thin wrapper around existing shell utilities.

EXAMPLES
     viro env set NODE_ENV development
             set any environment variable

     viro path add ~/.bin
             add directories to your PATH

     viro fn new my-shell-fn
             create a shell function

     viro fn edit my-shell-fn
             edit it

ENVIRONMENT
     VIRO_SRC
             Where the viro source files live

     VIRO_USER
             Where your personal viro configuration files live. Default: $HOME/.viro

FILES
     VIRO_USER/ENV
             where viro stores your env variables

     VIRO_USER/PATH
             where viro stores your PATH

     VIRO_USER/functions
             where viro stores your shell functions
```

# Install

## Dependencies
- fzf
- realpath
- bat

```sh
git clone https://github.com/talon/viro
VIRO_SRC="$(pwd)/viro/src" . viro/src/core.sh && viro install
```

# Try

```sh
docker run -it --rm talon/viro
```
