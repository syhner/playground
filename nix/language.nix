# each file returns a single expression
# import <filepath> brings in the expression from a file
# nix eval --file language.nix
{
  key1 = "value";
  key2 = 1 + 1;
}
