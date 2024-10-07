# ./overlays/default.nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./mutterX11.nix)
  ];
}