# bash-cli
> template for building command-line interfaces with Bash ⌨

# Usage

rename [`./say`](./say) to your desired command name
```sh
mv say [your command name]
```

edit it to your hearts content
```sh
$VISUAL say
```

to make your command available from any directory be sure to add it's directory to your `PATH`!

# Example

the template `./say` command comes with an example parameter `hello` that takes an optional flag `--to`

```sh
./say hello --to cpubae
```
