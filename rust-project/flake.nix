{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk";
  };

  outputs =
    {
      self,
      nixpkgs,
      naersk,
    }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      naerskLib = pkgs.callPackage naersk { };
    in
    {

      devShells."aarch64-darwin".default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          rustc
          rustfmt
          clippy
          rust-analyzer
          glib
        ];

        nativeBuildInputs = with pkgs; [
          pkg-config
        ];

        env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };

      # packages."aarch64-darwin".default = pkgs.rustPlatform.buildRustPackage {
      #   name = "my-app";
      #   src = ./.;
      #   buildInputs = with pkgs; [
      #     glib
      #   ];
      #   nativeBuildInputs = with pkgs; [
      #     pkg-config
      #   ];
      #   cargoLock.lockFile = ./Cargo.lock;
      # };

      # packages."aarch64-darwin".default = pkgs.callPackage ./default.nix { };

      packages."aarch64-darwin".default = naerskLib.buildPackage {
        src = ./.;
        buildInputs = [ pkgs.glib ];
        nativeBuildInputs = [ pkgs.pkg-config ];
      };
    };

}
