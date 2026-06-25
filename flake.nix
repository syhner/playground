{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        script1 = pkgs.writeShellScriptBin "script1" ''
          echo "hello from script1" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
        '';

        # nix run .#script2
        script2 = pkgs.writeShellScriptBin "script2" ''
          echo "hello from script2" | ${pkgs.lolcat}/bin/lolcat | ${pkgs.lolcat}/bin/lolcat
        '';

        # nix run
        default = self.packages.${system}.script1;
      };
    };
}
