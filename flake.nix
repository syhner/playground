{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # nix develop
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

      packages.${system} = {
        # nix run .#script1
        script1 = pkgs.writers.writeBashBin "script1" (builtins.readFile ./script.sh);

        # nix run .#script2
        script2 = pkgs.writeShellScriptBin "script2" ''
          echo "hello from script2" | ${pkgs.lolcat}/bin/lolcat | ${pkgs.lolcat}/bin/lolcat
        '';

        # nix run
        default = self.packages.${system}.script1;
      };
    };
}
