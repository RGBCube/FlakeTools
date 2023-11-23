{
  description = " A simpler and less bug-prone flake-utils alternative. ";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs, ... }: {
    # Makes a single set from a provided `function` and a `list`
    # by mapping and then recursively updating each item together.
    #
    # It first takes the list and applies the function to each item:
    #
    # `[ 1 2 3 ] => [ (f 1) (f 2) (f 3) ]`
    #
    # Assuming our function was `i: { squares."${i}" = i*i; "}`, this step would give us this:
    #
    # `[ { squares."1" = 1; } { squares."2" = 4; } { squares."3" = 9; } ]`
    #
    # Then it recursively updates them into a single attribute set, giving us our result:
    #
    # `{ squares = { "1" = 1; "2" = 4; "3" = 9; }; }`
    recursiveUpdateMap = function: list:
      builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map function list);

    # List of all architectures nixpkgs supports.
    allArches = import ./allSystems.nix;

    # List of the most commonly used architectures.
    # Currently these are aarch64-darwin, aarch64-linux, x86_64-darwin and x86_64-linux.
    defaultArches = import ./defaultSystems.nix;

    # Equivalent to `recursiveUpdateMap <function-passed-in> allArches`.
    #
    # Calls the given function with **all** architectures nixpkgs supports.
    # Then it merges them together using nixpkgs' `lib.recursiveUpdate`.
    #
    # WARNING: You probably want to use `eachDefaultArch` instead,
    # since this will take a while when running `nix flake check`.
    eachArch = function: self.recursiveUpdateMap function self.allArches;

    # Equivalent to `recursiveUpdateMap <function-passed-in> defaultArches`.
    #
    # Calls the given function with the most commonly used architectures
    # (currently these are aarch64-darwin, aarch64-linux, x86_64-darwin and x86_64-linux).
    # Then it merges them together using nixpkgs' `lib.recursiveUpdate`.
    eachDefaultArch = function: self.recursiveUpdateMap function self.defaultArches;
  };
}
