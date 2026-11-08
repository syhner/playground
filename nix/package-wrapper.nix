{
  lib,
  stdenv,
  ffmpeg,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gifgen";
  version = "1.2.0";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 gifgen $out/bin/gifgen
    # lib.makeBinPath [ ffmpeg ] means
    # "Give this application access to the directory containing FFmpeg's
    # executable, regardless of whether FFmpeg is installed system-wide."
    wrapProgram $out/bin/gifgen \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
    runHook postInstall
  '';
})

# combine existing packages without rebuilding or copying contents
# { symlinkJoin, ripgrep, makeWrapper }:
# symlinkJoin {
#   name = "ripgrep";
#   paths = [ ripgrep ];
#   nativeBuildInputs = [ makeWrapper ];
#   postBuild = ''
#     wrapProgram $out/bin/rg --set RIPGREP_CONFIG_PATH ${./ripgreprc}
#   '';
# }
