{
  pkgs,
  lib,
  ...
}:
let
  stableKanataDir = "/usr/local/libexec/nix-darwin/kanata";
  stableKanataBin = "${stableKanataDir}/kanata";
in
{
  system.activationScripts.preActivation.text = ''
    mkdir -p ${stableKanataDir}
    install -m 0755 ${lib.getExe pkgs.kanata} ${stableKanataBin}
  '';

  launchd.daemons.kanata = {
    serviceConfig = {
      ProgramArguments = [
        stableKanataBin
        "--cfg"
        "/Users/siraj/.config/kanata/kanata.kbd"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      StandardOutPath = "/tmp/kanata.out.log";
      StandardErrorPath = "/tmp/kanata.err.log";
    };
  };

  launchd.daemons.karabiner-vhid = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.karabiner-dk}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Interactive";
      StandardOutPath = "/tmp/karabiner-vhid.out.log";
      StandardErrorPath = "/tmp/karabiner-vhid.err.log";
    };
  };
}
