# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
# --mode disko /tmp/disko.nix \
# --argstr device "/dev/nvme0n1" \
# --arg swapSize 8

# sudo nixos-generate-config \
#   --no-filesystems --root /mnt
{
  device ? throw "Set this to your device, e.g. /dev/nvme0n1",
  swapSize
}:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            size = "512MiB";
            type = "EF00";
            label = "boot";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "default" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true; # SSD optimization
                bypassWorkqueues = true; # SSD optimization
              };
              # encrypt the root partition with luks2 and argon2id, will prompt for a passphrase, which will be used to unlock the partition.
              # cryptsetup luksFormat
              extraFormatArgs = [
                "--type luks2"
                "--cipher aes-xts-plain64"
                "--hash sha512"
                "--iter-time 5000"
                "--key-size 256"
                "--pbkdf argon2id"
                # use true random data from /dev/random, will block until enough entropy is available
                "--use-random"
              ];
              extraOpenArgs = [
                "--timeout 10"
              ];
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        # swap = {
        #   name = "swap";
        #   size = swapSize;
        #   content = {
        #     type = "swap";
        #     resumeDevice = true; # resume from hiberation from this device
        #   };
        # };
        nixos = {
          # Uses different format for specifying size
          # Based on `lvcreate` arguments
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing filesystem
            # Subvolumes must set a mountpoint in order to be mounted
            # unless its parent is mounted
            subvolumes = let
              mountOptions = [
                "compress=zstd"
                "noatime"
                "nodiratime"
                "discard"
                "nofail"
              ];
            in {
              "@root" = {
                mountpoint = "/";
                inherit mountOptions;
              };
              "@nix" = {
                mountOptions = [ "subvol=nix" ] ++ mountOptions;
                mountpoint = "/nix";
              };
              "@log" = {
                inherit mountOptions;
                mountpoint = "/var/log";
              };
              "@tmp" = {
                mountpoint = "/tmp";
                mountOptions = [ "noatime" ];
              };
              "@persist" = {
                mountOptions = [ "subvol=persist" ] ++ mountOptions;
                mountpoint = "/persist";
              };
              "@snapshots" = {
                mountOptions = [ "subvol=snapshots" ] ++ mountOptions;
                mountpoint = "/.snapshots";
              };
              "@swap" = {
                mountpoint = "/.swapvol";
                mountOptions = [ "noatime" ]
                swap.swapfile.size = "${swapSize}G";
              };
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        # set mode to 755, otherwise systemd will set it to 777, which cause problems.
        # relatime: Update inode access times relative to modify or change time.
        "mode=755"
      ];
    }
  };
  fileSystems."/persist".neededForBoot = true; # required by impermanence
  fileSystems."/var/log".neededForBoot = true; # required by nixos
}
