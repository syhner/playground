{
  rustPlatform,
  glib,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  name = "rust-project";
  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config ];
}
