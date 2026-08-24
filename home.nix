{ config, pkgs, ... }:

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
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables.EDITOR = "nvim";

  # zsh defaults
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;     # ghost text from history
    syntaxHighlighting.enable = true; # commands turn green when valid
    initContent = ''
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

home.file.".claude/settings.json".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

home.file.".claude/identity.md".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/identity.md";

home.file.".claude/CLAUDE.md".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
