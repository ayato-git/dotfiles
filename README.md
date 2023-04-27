# dotfiles

Bootstrap environment for macOS on intell/AppleSilicon

## Usage

```sh
./install.sh --dry-run
./install.sh # apply
```

`install.sh` gets [mitamae](https://github.com/itamae-kitchen/mitamae),
and runs mitamae with `recipe.rb`.

## TODO

- Set config dir according to XDG Base Directory Specification.
- remove old setting files like xxxx.old.toml
