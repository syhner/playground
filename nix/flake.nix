{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # # equivalent to
    # nixpkgs = {
    #   type = "github";
    #   owner = "NixOS";
    #   repo = "nixpkgs";
    #   ref = "nixos-26.05";
    # };
  };

  outputs =
    {
      # `self` is this flake's own outputs
      self,
      nixpkgs,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # -------------------------------
      # nix build = nix build . = nix build .#default
      # -------------------------------
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "name2";
        src = ./.;
        # runtime dependencies
        buildInputs = [ ];
        # buildtime dependencies
        nativeBuildInputs = [ ];
        unpackPhase = "#shell logic";
        buildPhase = "echo 'hello world from mkDerivation' > $out";
        installPhase = "# shell logic ";
      };
      # > cat result
      # hello world from mkDerivation

      # -------------------------------
      # nix run (prefers apps.default, falls back to packages.default)
      # -------------------------------
      apps.${system} = {
        # > nix run
        default = self.apps.${system}.script1;

        # > nix run .#script1
        script1 = {
          type = "app";
          program = pkgs.writeShellScriptBin "script2" ''
            echo "hello from script2" | ${pkgs.lolcat}/bin/lolcat | ${pkgs.lolcat}/bin/lolcat
          '';
        };

        # > nix run .#script2
        script2 = {
          type = "app";
          program = pkgs.writers.writeBashBin "script1" (builtins.readFile ./script.sh);
        };
      };

      # -------------------------------
      # nix develop
      # -------------------------------
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nodejs
        ];

        shellHook = ''
          echo "Welcome"
          echo "to my shell!" | ${pkgs.lolcat}/bin/lolcat
        '';

        COLOR = "blue";
        PASSWORD = import ./password.nix;
      };
    };
}
