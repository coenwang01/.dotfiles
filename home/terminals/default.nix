{ mylib, ... }: {
  imports = mylib.scanPaths ./.;
}
