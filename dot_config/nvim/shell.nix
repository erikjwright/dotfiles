let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    cargo
    clang
    lua
    lua-language-server
    nodejs_22
    rustc
    stylua
    tree-sitter
    zig
  ];
}
