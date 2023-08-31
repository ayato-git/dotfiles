# dotfiles

Bootstrap environment for macOS on intell/AppleSilicon

## Usage

```sh
./install.sh --dry-run
# output verbose
./install.sh --dry-run --log-level=DEBUG
# apply
./install.sh
```

`install.sh` gets [mitamae](https://github.com/itamae-kitchen/mitamae),
and runs mitamae with `files/recipe.rb`.
mitamae is single binary.

## Note

- Set config dir according to XDG Base Directory Specification.
