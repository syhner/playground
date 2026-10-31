# code ----derivation----> package
# all packages get built into /nix/store/<hash>-<name>-<version>
# can skip compilation if in cache (e.g. cache.nixos.org) or in store
# if derivation doesn't change, nix doesn't rebuild the package

# > nix build ./derivation.nix
# > cat result
# hello world from derivation
let
  hello-world = derivation {
    name = "name";
    builder = "/bin/sh";
    args = [
      "-c"
      # nix sets $out to the place the builder is allowed to write to
      "echo 'hello world' > $out"
    ];
    system = "aarch64-darwin";
  };
in
# these are equivalent, string interpolation of a derivation or path gives a store path
[
  # "/nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world"
  hello-world.outPath
  # "/nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world"
  "${hello-world}"
  # "/nix/store/h9sdbfub23jbu91nvkzb92bsoq9zjb84-hello-world"
  "${./script.sh}"
]

# nix-instantiate derivation.nix
# -> /nix/store/dp5na63mzhc3a2kkiy37b3xq642k7lhy-hello-world.drv

# cat /nix/store/dp5na63mzhc3a2kkiy37b3xq642k7lhy-hello-world.drv
# -> Derive([("out","/nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world","","")],[],[],"x86_64-linux","/bin/sh",["-c","echo hello world > $out"],[("builder","/bin/sh"),("name","hello-world"),("out","/nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world"),("system","x86_64-linux")])

# nix-store --realise /nix/store/dp5na63mzhc3a2kkiy37b3xq642k7lhy-hello-world.drv
# -> /nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world
# cat /nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world
# -> hello world

# nix-build derivation.nix
# -> /nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world
#    (also creates ./result -> /nix/store/kbh84yclhgn33j34j9i4wxha04v79q5f-hello-world)
# cat result
# -> hello world
