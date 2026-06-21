{
  ...
}:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "mas"
      "mole"
    ];
    casks = [
      "obs"
      "vlc"
      "ghostty"
      "stremio"
      "monitorcontrol"
      "helium-browser"
      "steam"
      # gets stuck on installing helper tool when installed through nixpkgs
      "discord"
    ];
    masApps = {
      "Keynote" = 361285480;
    };
  };
}
