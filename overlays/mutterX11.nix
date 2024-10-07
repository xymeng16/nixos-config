final: prev: {
  # elements of pkgs.gnome must be taken from gfinal and gprev
  gnome = prev.gnome.overrideScope (gfinal: gprev: {
    mutter = gprev.mutter.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        # https://salsa.debian.org/gnome-team/mutter/-/blob/ubuntu/master/debian/patches/x11-Add-support-for-fractional-scaling-using-Randr.patch
        (prev.fetchpatch {
          url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/7aa432d4366fdd5a2687a78848b25da4f8ab5c68/x11-Add-support-for-fractional-scaling-using-Randr.patch";
          hash = "";
        })
        # (prev.fetchpatch {
        #   url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/64f7d7fb106b7efb5dfb3f86c3bcf9a173ee3c5e/Support-Dynamic-triple-double-buffering.patch";
        #   hash = "";
        # })
    ];
    });
  });
}