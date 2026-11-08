{
  stdenv,
  fetchurl,
  htop,
  lib,
}:

# stdenv.mkDerivation wraps `derivation` with C stuff
# buildPythonPackage, buildRustPackage, nixosSystem, mkShell, etc. are wrappers around stdenv.mkDerivation with language specific features
# finalAttrs is used to reference locally defined variables
stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "2.12.3";
  # override package input defaults
  htop-vim = htop.override { withVimKeys = true; };

  # fetcher - has network access, verified with hash
  src = fetchurl {
    # mirror://gnu is the nixpkgs shorthand for GNU download mirrors
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    hash = "sha256-DV9gFUOC/uELEUocNOeF2LH0kgc64tOm97FHaHs2aqA=";
    # useful for getting actual hash
    # hash = lib.fakeHash;
  };

  # can be more explicit with src files to avoid rebuilds
  # src = lib.fileset.toSource {
  #    root = ./.;
  #    fileset = lib.fileset.unions [ ./main.c ./Makefile ];
  #  };

  # libraries needed during being built
  nativeBuildInputs = [ ];
  # libraries needed after being built
  buildInputs = [ ];

  # build phases:
  # unpackPhase    - unpacks src
  # patchPhase     - applies your patches
  # configurePhase - runs ./configure, if the project has one
  # buildPhase     - runs make
  # checkPhase     - runs the project’s tests
  # installPhase   - runs make install
  # fixupPhase     - tidies up the result, for example by cutting debug info out of programs to make them smaller

  # override installPhase that comes with stdenv.mkDerivation
  # installPhase = ''
  #   # when phase is overridden, hook does not run unless specified
  #   runHook preInstall
  #
  #   install -Dm755 -t $out/bin hello
  #   install -Dm644 -t $out/share/man/man1 hello.1{,.ja}
  #
  #   runHook postInstall
  # '';

  # run the check phase (default is false)
  doCheck = true;
})

# call package.nix, substituting any missing inputs from nixpkgs (like htop)
# pkgs.callPackage ./package.nix { }

# override attributes `mkDerivation` is handed
# let
#   hello = pkgs.stdenv.mkDerivation {
#     pname = "hello";
#     version = "2.12.3";
#     src = pkgs.fetchurl {
#       url = "mirror://gnu/hello/hello-2.12.3.tar.gz";
#       hash = "sha256-DV9gFUOC/uELEUocNOeF2LH0kgc64tOm97FHaHs2aqA=";
#     };
#   };
# in
# {
#   before = hello.src.url;
#   after = (hello.overrideAttrs { src = ./hello; }).src;
# }

# override package inside package set
# works globally if set to nixpkgs.overlays (used by NixOS and home-manager)
# final is nixpkgs after changes from overlays, prev is nixpkgs before
# overlays = [
#   (final: prev: {
#     # allow kanata to run shell commands
#     htop-vim = prev.htop.override { withVimKeys = true; };
#   })
