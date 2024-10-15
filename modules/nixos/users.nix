{
  myvars,
  config,
  ...
}: let
  cfgUser = config.users.users."${myvars.userName}";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users = {
    # Don't allow mutation of users outside the config.
    mutableUsers = false;

    groups = {
      "${myvars.userName}" = {};
      docker = {};
      wireshark = {};
      # for android platform tools's udev rules
      adbusers = {};
      dialout = {};
      # for openocd (embedded system development)
      plugdev = {};
      # misc
      uinput = {};
    };
    users = {
      "${myvars.userName}" = {
        # generated by `mkpasswd -m scrypt`
        # we have to use initialHashedPassword here when using tmpfs for /
        initialHashedPassword = "$y$j9T$UtvejDe22fK.4ok7ZyI1Y/$.vc/kQ3hRFbb2ntOCQQna3CcWWP6dxwtEAE1O9bWcO8";
        home = "/home/${myvars.userName}";
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ] ++ ifTheyExist [
          myvars.userName
          "users"
          "git"
          "networkmanager"
          "docker"
          "wireshark"
          "adbusers"
          "libvirtd"
        ];
      };
      # root's ssh key are mainly used for remote deployment
      root = {
        inherit (cfgUser) initialHashedPassword;
        openssh.authorizedKeys.keys = cfgUser.openssh.authorizedKeys.keys;
      };
    };
  };
}
