{ mylib, ... }: {
  imports = mylib.scanPaths ./.;
}

