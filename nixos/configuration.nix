# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "8086k"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_HK.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl         
     git
     tailscale
  ];

  environment.variables.EDITOR = "nvim";

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xiangyi = {
    isNormalUser = true;
    description = "Xiangyi Meng";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
    	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4ftbnxeQ2SEPZgL/A5u7zfDbP6WuUdkrNw94kK37BPTLJfb37XLJTUx07aSBgI9uWN3n/W7VBh55W77eOcqzjaGUgbx2VxRoLAJeZxCH3j+uAYyQZqSJeVOT+GDB1AsCux42y5lKwA87bz/Z6f+IhNk3uGBf5VE+gT8Jf0i5eBt3UOb5Dbqs85KBAuzyr8/sSAXxcMg6MPpOkrMz9N2PBSnd7lW90rsLSvW2+A38aUHemnBadDlUMhreq0NPNgxjhzkhgLxpuyQzv325oFXP0ahHydii4CblnQm0rewzr7NLFk7b7m1O2YWFKziBkC5MvraJZvwZ0jUfVbaMR0ptpOPfcBck4Eu5MFU+JIpBDAMPBgWLV+S5awi9IjnlHldiu8bjui+h3QD6Paw7TT40b/Dk0v0XkJ2ZqfnperW92swgKs9TFZaW9mHdrQ/uAB7jwUjBtjCJzep5fnUrO2hqRNiHWOzEkar4V2XeoPe10nvxC95W/TbZ4FIO9R2epaN8= xiangyi@Xiangyis-Mac-mini.local"
    ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
