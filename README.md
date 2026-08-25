# Personal dotfiles of Hugo Åkerstrand 

These files reproduce my personal macOS settings, using [nix-darwin][nix-darwin].

NB! I don't recommend that you take them at face-value. I share them as a point-of-reference for whom it may concern.

### Don't know how to get started?
Do like I did, start with [Kun Chen's excellent YouTube guide][youtube-guide].

### Layout
- `configuration.nix` - system-level nix-darwin config
- `home.nix` - user-level home-manager config
- `home/` - home-manager modules

### Apply
```
./rebuild.sh
```
Symlinks this repo to `~/.dotfiles` and runs `darwin-rebuild switch`.

[nix-darwin]: https://github.com/nix-darwin/nix-darwin/
[youtube-guide]: https://youtu.be/5N-okeDdIuI?si=zPuX0zRWFgkI2KZp
