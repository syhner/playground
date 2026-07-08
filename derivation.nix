# code ----derivation----> package
# all packages get built into /nix/store/<hash>-<name>-<version>
# can skip compilation if in cache (e.g. cache.nixos.org) or in store
# if derivation doesn't change, nix doesn't rebuild the package
# stdenv.mkDerivation is more convenient than just derivation
# buildPythonPackage, buildRustPackage, nixosSystem, mkShell, etc. are wrappers around stdenv.mkDerivation with language specific features

# > nix build ./derivation.nix
# > cat result
# hello world from derivation
derivation {
  name = "name";
  builder = "/bin/sh";
  args = [
    "-c"
    "echo 'hello world' > $out"
  ];
  system = "aarch64-darwin";
}
