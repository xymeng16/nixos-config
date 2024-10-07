# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... } :

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
# Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead  
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = "tortuga"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; 
  
  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_HK.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # # Enable the GNOME Desktop Environment.
  # nixpkgs.overlays = [
  #   (import ./overlays/mutterX11.nix)
  # ];
  # nixpkgs.overlays = [
  #   (
  #     final: prev: {
  #       # elements of pkgs.gnome must be taken from gfinal and gprev
  #       gnome = prev.gnome.overrideScope (gfinal: gprev: {
  #         mutter = gprev.mutter.overrideAttrs (oldAttrs: {
  #           # version = oldAttrs.version + "-patched";
  #           patches = (oldAttrs.patches or []) ++ [
  #             # https://salsa.debian.org/gnome-team/mutter/-/blob/ubuntu/master/debian/patches/x11-Add-support-for-fractional-scaling-using-Randr.patch
  #             (prev.fetchpatch {
  #               url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/7aa432d4366fdd5a2687a78848b25da4f8ab5c68/x11-Add-support-for-fractional-scaling-using-Randr.patch";
  #               hash = "13xx5pk29307k6075j087hp8lfpklfbm7i1xlr753ia6hd2lizsl";
  #             })
  #           #   # (prev.fetchpatch {
  #           #   #   url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/64f7d7fb106b7efb5dfb3f86c3bcf9a173ee3c5e/Support-Dynamic-triple-double-buffering.patch";
  #           #   #   hash = "";
  #           #   # })
  #           ];
  #         });
  #       });
  #     }
  #   )
  # ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     gnome = prev.gnome.overrideScope (gfinal: gprev: {
  #       mutter = gprev.mutter.overrideAttrs (oldAttrs: {
  #         version = oldAttrs.version + "-patched";
  #       });
  #     });
  #   })
  # ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     hello = prev.hello.overrideAttrs (oldAttrs: {
  #       name = "hello-patched";
  #     });
  #   })
  # ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable KDE
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and new commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget 
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl         
    git
    tailscale
    nixos-generators
    inputs.wezterm.packages.${pkgs.system}.default # workaround for https://github.com/wez/wezterm/issues/5990
    # (import
    #   (builtins.fetchGit {
    #     url = "github:wez/wezterm/main?dir=nix";
    #     ref = "main";
    #     rev = "a2f2c07a29f5c98f6736cde0c86b24887f9fd48a"; 
    #   })
    #   { inherit system; }).wezterm  
  ];
  
  environment.variables.EDITOR = "neovim";

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "IBMPlexMono"]; })
  ];  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable OpenSSH server
  services.openssh = {
     enable = true;
     settings = {
        X11Forwarding = true;
	PermitRootLogin = "no";
	PasswordAuthentication = false;
     };
     openFirewall = true;
  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
