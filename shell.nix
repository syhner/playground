{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  shellHook = ''
    echo "Welcome"
    echo "to my shell!" | ${pkgs.lolcat}/bin/lolcat
  '';
}
