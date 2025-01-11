{
  nixos-wsl,
  ...
}: {
  modules = [
    ./__config
    nixos-wsl.nixosModules.default
    home-manager.nixosModules.home-manager
    nixos-generators.nixosModules.all-formats
    programs-sqlite.nixosModules.programs-sqlite
  ]
}
