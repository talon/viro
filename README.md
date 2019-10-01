# Install

```sh
git clone https://github.com/talon/viro ~/.viro/
~/.viro/viro install
```
> put this repo somewhere and then use [`./viro`](./viro) `install` to strap in

# viro(1)

1.0, 09 Sept 2019


# Name

viro - an environment manager

# Synopsis

viro
**install**

viro
**refresh**

viro
**boot**

viro
**[env|alias|path]**
ls

viro
**[env|alias|path]**
edit

viro
**[env|alias|path]**
add
_name_
_value_

viro
**[env|alias|path]**
rm
_name_
_value_

viro
**[env|alias|path]**
has
_name_


# Description

viro makes managing your environment simple

# Environment


* **VIRO_HOME**
  path where viro manages its internal files

# Files


* **$VIRO_HOME/user/ENV**
  your environment variables
* **$VIRO_HOME/user/aliases**
  your aliases
* **$VIRO_HOME/user/PATH**
  your PATH
* **$VIRO_HOME/user/boot.sh**
  for startup script stuff
* **$VIRO_HOME/user/bins**
  the folder with any bins you've created

# Author

Talon Poole (hello@talon.computer)

# Copywrite

Copyright © 2019 Talon Poole.
License GPLv3+: GNU GPL version 3 or later &lt;http://gnu.org/licenses/gpl.html&gt;.

This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
