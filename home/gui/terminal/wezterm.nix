{ pkgs, ... }: {
  programs.wezterm = {
    enable = true;

    enableBashIntegration = pkgs.stdenv.isLinux;
    enableZshIntegration = pkgs.stdenv.isLinux;

    extraConfig = (builtins.readFile ./wezterm.lua);
  };
}
