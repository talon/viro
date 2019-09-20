# bin
> ⌨ a command line interface for creating command line interfaces (with Bash)

# Install

```
git clone https://github.com/talon/bash-cli-template ~/.bin/
echo "PATH=PATH:$HOME/.bin/bins" >> ~/.bashrc
```
> basically just put this repo somewhere and add [bins](./bins)  to your `PATH` 

# Usage

```
bin create [name] # create (or edit) [name] with $VISUAL
bin remove [name] # remove bin
bin show # show all bins
bin src # create a .sh file that other bins can `use`
```

# Example

[![asciinema]( https://asciinema.org/a/269700.svg)](https://asciinema.org/a/269700)
