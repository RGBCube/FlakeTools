# FlakeTools

A simpler and less bug-prone flake-utils alternative.

Currently has only the basics, but I will expand the functionality soon.

## API

### `eachDefaultArch :: (string -> attrset) -> attrset`
### `eachDefaultLinuxArch :: (string -> attrset) -> attrset` (only Linux architectures)

Equivalent to `recursiveUpdateMap <function-passed-in> defaultArches`.

Calls the given function with the most commonly used architectures
(currently these are `aarch64-darwin`, `aarch64-linux`, `x86_64-darwin` and `x86_64-linux`).
Then it merges them together using nixpkgs' `lib.recursiveUpdate`.

> [!WARNING]
> `eachDefaultArch` does NOT insert the arch into the attribute set
> unlike flake-utils, so you have to manually use it like so:

```nix
{
  description = "Blazingly fast tool written in Rust.";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    flakeTools = {
      url = "github:RGBCube/FlakeTools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flakeTools, ... }: flakeTools.eachArch (system: {
    packages.${system}.default = <deviration>;
  })
}
```

> [!NOTE]
> This also applies to `eachArch`.

### `eachArch :: (string -> attrset) -> attrset`

Equivalent to `recursiveUpdateMap <function-passed-in> allArches`.

Calls the given function with **all** architectures nixpkgs supports.
Then it merges them together using nixpkgs' `lib.recursiveUpdate`.

> [!WARNING]
> You probably want to use `eachDefaultArch` instead,
> since this will take a while when running `nix flake check`.

### `allArches :: [ string ]`

List of all architectures nixpkgs supports.

### `defaultArches :: [ string ]`

List of the most commonly used architectures.
Currently these are `aarch64-darwin`, `aarch64-linux`, `x86_64-darwin` and `x86_64-linux`.

### `recursiveUpdateMap :: (string -> attrset) -> list -> attrset`

Makes a single set from a provided `function` and a `list`
by mapping and then recursively updating each item together.

It first takes the list and applies the function to each item:

`[ 1 2 3 ] => [ (f 1) (f 2) (f 3) ]`

Assuming our function was `i: { squares."${i}" = i*i; "}`, this step would give us this:

`[ { squares."1" = 1; } { squares."2" = 4; } { squares."3" = 9; } ]`

Then it recursively updates them into a single attribute set, giving us our result:

`{ squares = { "1" = 1; "2" = 4; "3" = 9; }; }`

## License

```
MIT License

Copyright (c) 2023-present RGBCube

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
