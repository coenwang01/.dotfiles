# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, disko, ... }: let
  hostName = "oldman";
  disko-config = import ../../_internal/disko.nix {
    inherit lib;
    device = "/dev/nvme0n1";
    withSwap = true;
    swapSize = "8G";
  };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      disko.nixosModules.disko
      disko-config
      ./boot.nix
      # ../../_internal/lanzaboote.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    inherit hostName;
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
