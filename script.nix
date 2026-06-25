{ pkgs }:

pkgs.writeShellScriptBin "example-script" ''
  echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
