# nixcats-nvim

Personal neovim configurations, supporting unix-like systems, no matter [`nix`](https://nixos.org) installed or not. Built on top of the awesome project [BirdeeHub/nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim).

Most of the configuration is a variant of [folke/LazyVim](https://www.lazyvim.org).

![screenshot](https://github.com/user-attachments/assets/77e71db0-5c1c-4073-a762-434cbece0191)

There are two packages in this flake:
- "`minimal`": A configuration that doesn't include desktop/GUI-only features, specialized for remote server usage. I use [GitHub Actions](./.github/workflows/x86_64-linux-minivim.yml) to package it into a AppImage. Although its name is `minivim`, it's still bulky :(
- `nvim`: The default configuration, with all features enabled.

See [BirdeeHub/nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim) for more information.

## Try it out

### The `nix` way

If you have `nix` installed, you can try it out by running:

```console
$ nix run github:Fr4nk1inCs/nixcats-nvim
```

Or, if you want to use the `minimal` package:

```console
$ nix run github:Fr4nk1inCs/nixcats-nvim#minimal
```

### Non-`nix` way

If you don't have `nix` installed, you can still try it out by running:

```console
$ git clone https://github.com/Fr4nk1inCs/nixcats-nvim ~/.config/nvim
```

Make sure you have `neovim` installed, and take care of your original configuration files.

## Credits

- [BirdeeHub/nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim)
- [folke/LazyVim](https://github.com/folke/LazyVim)
