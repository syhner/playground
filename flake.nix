{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration = { pkgs, ... }: {
        networking.hostName = "smacbook";
        networking.computerName = "smacbook";
        
        # Allow packages with unfree licenses.
        nixpkgs.config.allowUnfree = true;

        system.activationScripts.extraActivation.text = ''
          softwareupdate --install-rosetta --agree-to-license
        '';

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.git
          pkgs.neovim
          pkgs.tmux
          pkgs.obsidian
          pkgs.nil
          pkgs.nixd
        ];

        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
        ];

        system.primaryUser = "siraj";

        homebrew = {
          enable = true;
          brews = [
            "mas"
            "mole"
          ];
          casks = [
            "obs"
            "vlc"
            "ghostty"
          ];
          masApps = {
            "Keynote" = 361285480;
          };
        };

        system.defaults = {
          dock.autohide = true;
          finder.FXPreferredViewStyle = "clmv";
        };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#smacbook
      darwinConfigurations."smacbook" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "siraj";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
