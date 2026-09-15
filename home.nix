{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "hugoakerstrand";
  home.homeDirectory = "/Users/hugoakerstrand";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    neovim
    nerd-fonts.hack
    google-cloud-sdk
  ];

  fonts.fontconfig.enable = true;

  # uv-managed CLI tools that have no brew formula or nixpkgs package.
  # Re-runs on every `./rebuild.sh`, mirroring homebrew's upgrade-on-activation.
  # Binaries land in ~/.local/bin, already on PATH via home.sessionPath.
  home.activation.uvTools =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="/opt/homebrew/bin:${config.home.homeDirectory}/.local/bin:$PATH"
      run uv tool install --upgrade data-dict-yaml
    '';

  # npm-managed CLI tools that have no brew formula or nixpkgs package.
  # ajv-cli is a JSON Schema validator; ajv-formats adds date/email/etc. formats.
  # Re-runs on every `./rebuild.sh` against the homebrew node from configuration.nix.
  home.activation.npmTools =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="/opt/homebrew/bin:$PATH"
      run npm install -g ajv-cli ajv-formats
    '';

  home.sessionVariables.EDITOR = "nvim";
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # zsh defaults
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;     # ghost text from history
    syntaxHighlighting.enable = true; # commands turn green when valid
    defaultKeymap = "viins";          # vi bindings, starting in insert mode like vim
    initContent = ''
      KEYTIMEOUT=1 # ms to wait after Esc before dropping to normal mode (default 400ms feels laggy)
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      # ".." = "cd ..";
      # add = "git add .";
      # push = "git push";
      # pull = "git pull";
      #m = "git switch main";
      cc = "claude"; #"claude --dangerously-skip-permissions"
      #co = "codex --full-auto";
    };
  };

  # Git settings
  programs.git.settings.user = {
    name = "hugoakerstrand";
    email = "hugoakerstrand@gmail.com";
  };

  # Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[>](purple)";
        error_symbol = "[>](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
home.file.".config/wezterm".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";

home.file.".config/nvim/".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";

home.file.".config/herdr/".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";

home.file.".claude/settings.json".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

home.file.".claude/identity.md".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/identity.md";

home.file.".claude/CLAUDE.md".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

# Multi-account Google Workspace CLI wrappers (see home/bin/gws-acct).
# ~/.local/bin is already on PATH via home.sessionPath above.
home.file.".local/bin/gws-acct".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/gws-acct";

home.file.".local/bin/gws-personal".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/gws-personal";

home.file.".local/bin/gws-work".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/gws-work";

# Personal Claude Code skills. mkOutOfStoreSymlink so edits in the repo take
# effect without a rebuild. Coexists with skill-manager symlinks in the same dir.
home.file.".claude/skills/email-accounts".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/skills/email-accounts";
}
