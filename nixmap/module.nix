{
  # header `config` which holds the final value after the module system has
  # evaluated all module's `config`s
  config,
  # if using flakes, this comes from flake.nix as `specialArgs = { inherit inputs; };`
  inputs,
  lib,
  pkgs,
  ...
}:

let
  # common lias for the final merged configuration of this module's config
  cfg = config.programs.git;
in

# module should be/return a set of options.

{
  # these will get merged by the module system
  # if a file is referenced in `imports` across multiple modules, it is only counted once
  imports = [ ];

  # declares the variables which can be set
  options = {
    myApp.desktopApp.enable = lib.mkEnableOption "desktop apps";

    myApp.defaultBranch = lib.mkOption {
      type = lib.types.str;
      # custom type and merging strategy
      # type = lib.types.mkOptionType {
      #   name = "mergedBranch";
      #   # Only allow strings
      #   check = builtins.isString;
      #   # Custom merging strategy
      #   merge = loc: defs:
      #     lib.concatStringsSep "-" (map (def: def.value) defs);
      # };

      # priority 1500
      default = "main";
    };
  };

  # defines the values of the variables (which are defined in some module's `options`)
  # these items can be at the top level if `options` is not at the top level of this this attribute set
  # lib.mkMerge merges multiple configurations (as if they were separate modules)
  config = lib.mkMerge [
    { myApp.desktopApps.enable = true; }

    # priority 1000
    { myApp.defaultBranch = lib.mkDefault "main"; }

    # priority 100
    { myApp.defaultBranch = "main"; }

    # priority 50
    { myApp.defaultBranch = lib.mkForce "main"; }

    # lib.mkIf to tell the nix module system to defer evaluating the condition
    # until the module system processes configuration definitions
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
    })
  ];
}

# (lib.types.nullOr (lib.types.listOf lib.types.port)).description
# -> "null or (list of 16 bit unsigned integer; between 0 and 65535 (both inclusive))"
