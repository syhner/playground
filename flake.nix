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

        networking.hostName = "smacbook";
        networking.computerName = "smacbook";

        system.primaryUser = "siraj";

        system.defaults = {
          controlcenter.BatteryShowPercentage = true;

          NSGlobalDomain.ApplePressAndHoldEnabled = false;
          # 120, 90, 60, 30, 12, 6, 2
          NSGlobalDomain.KeyRepeat = 2;
          # 120, 94, 68, 35, 25, 15
          NSGlobalDomain.InitialKeyRepeat = 15;

          dock.autohide = true;
          dock.autohide-delay = 0.0;
          # Remove Dock auto-hide animation time
          dock.autohide-time-modifier = 0.0;
          # Show only open apps in Dock (no persistent/static apps)
          dock.static-only = true;

          finder.NewWindowTarget = "Desktop";
          finder.ShowPathbar = true;
          finder._FXSortFoldersFirst = true;
          # Allow quitting Finder with Cmd+Q
          finder.QuitMenuItem = true;
          # Prefer column view
          finder.FXPreferredViewStyle = "clmv";
        };

        # system.keyboard = {
        #   enableKeyMapping = true;
        #   remapCapsLockToEscape = true;
        # };

        # Allow packages with unfree licenses.
        nixpkgs.config.allowUnfree = true;

        system.activationScripts.extraActivation.text = ''
          if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
            softwareupdate --install-rosetta --agree-to-license
          fi
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
          pkgs.zed-editor
          pkgs.spotify
          # Karabiner-VirtualHIDDevice driver for kanata
          pkgs.karabiner-dk
          pkgs.kanata
          pkgs.discord
        ];

        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
        ];

        homebrew = {
          enable = true;
          onActivation.cleanup = "zap";
          brews = [
            "mas"
            "mole"
          ];
          casks = [
            "obs"
            "vlc"
            "ghostty"
            "stremio"
            "monitorcontrol"
            "helium-browser"
            "steam"
          ];
          masApps = {
            "Keynote" = 361285480;
          };
        };

        launchd.daemons.karabiner-vhid = {
          serviceConfig = {
            ProgramArguments = [
              "${pkgs.karabiner-dk}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
            ];
            KeepAlive = true;
            RunAtLoad = true;
            ProcessType = "Interactive";
          };
        };

        launchd.daemons.kanata = {
          serviceConfig = {
            ProgramArguments = [
              "${pkgs.kanata}/bin/kanata"
              "--cfg"
              "/Users/siraj/.config/kanata/kanata.kbd"
            ];
            RunAtLoad = true;
            KeepAlive = true;
            StandardOutPath = "/tmp/kanata.out.log";
            StandardErrorPath = "/tmp/kanata.err.log";
          };
        };
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
