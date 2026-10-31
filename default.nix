let
  pkgs = import <nixpkgs> { };
in
pkgs.callPackage ./package.nix { }

# nix build --file default.nix
# ./result/bin/hello
# -> Hello, world!
