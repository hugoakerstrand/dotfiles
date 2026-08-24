{ ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "hugoakerstrand";
  users.users.hugoakerstrand = {
    home = "/Users/hugoakerstrand";
  };
  system.stateVersion = 6;
 
  nix-homebrew.autoMigrate = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      _HIHideMenuBar = true;
      AppleShowAllExtensions = true;                               # show file extensions
      "com.apple.mouse.tapBehavior" = 1;                           # tap-to-click, global domain
      InitialKeyRepeat = 15;                                       # delay before repeat starts
      KeyRepeat = 2;                                               # key repeat speed
      NSAutomaticDashSubstitutionEnabled = false;                  # stop -- turning into –, breaks CLI flags
      NSAutomaticQuoteSubstitutionEnabled = false;                 # stop ' " turning into curly quotes, breaks pasted code
      NSAutomaticSpellingCorrectionEnabled = false;                # stop autocorrect mangling code/variable names
      "com.apple.sound.beep.volume" = 0.0;                        # mute the system alert/error beep
      #"com.apple.sound.beep.feedback" = 0;                        # don't flash screen instead of beep
    };
    dock.autohide = true;                                          # auto-hide the dock
    finder.AppleShowAllFiles = true;                               # show hidden files
    finder.CreateDesktop = false;                                  # hide desktop icons
    finder.FXPreferredViewStyle = "Nlsv";                          # default Finder windows to list view
    finder._FXSortFoldersFirst = true;                             # folders before files
    finder.ShowPathbar = true;                                     # show folder path bar
    screencapture.location = "~/Screenshots";                      # screenshot save location
    trackpad.Clicking = true;                                      # tap-to-click
  };
  nix-homebrew = {
    enable = true;
    user = "hugoakerstrand";
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    casks = [
      "wezterm"
      "claude-code"
      "quarto"
      "Rectangle"
    ];
    brews = [
      "tree"
      "herdr"
      "r"
      "gh"
      "node"
      "skills"
    ];
  };
}
