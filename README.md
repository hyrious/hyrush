`>_` A shell written & script in ruby, currently for windows only.

### How it smells

> Comments after '#' is equivalent ruby code.

```bash
> ls -a # system "ls -a"
.   ..    *a.rb
> 3 + 5 # p 3 + 5
8
> alias l="ls -C" # 'alias' is a built-in command, will store the alias for 'l'
> l # system "ls -C"
```

### Try it out

```bash
ruby hyrush.rb
```

### Todo

- [ ] support raw `\n` (ctrl-enter)
- [ ] give suggestions from history
- [ ] colorize codes and output

### License

MIT @ [hyrious](https://github.com/hyrious)
