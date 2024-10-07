{pkgs, ...}: {
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    keys = ["id_rsa"];
  };
}   