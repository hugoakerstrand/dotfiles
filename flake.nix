{
  description = "dotfiles";

  inputs = {

    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Install homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Install home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }: {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
	./configuration.nix 
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.backupFileExtension = "backup";
         home-manager.users.hugoakerstrand = import ./home.nix;
        }
      ];
    };
  };
}
