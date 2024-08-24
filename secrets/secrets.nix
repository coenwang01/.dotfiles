let
  # Get system's ssh public key by command:
  #    cat /etc/ssh/ssh_host_ed25519_key.pub
  # If you do not have this file, you can generate all the host keys by command:
  #    sudo ssh-keygen -A
  oldman = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrZLwck3qxSB1nXGmGqlI90mlTmBpZVu7XtCQ7lk/sR root@nixos";

  # A key for recovery purpose, generated by `ssh-keygen -t ed25519 -a 256 -C "johnson@agenix-recovery"` with a strong passphrase
  # and keeped it in a safe place.
  recovery_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNJK6LCNnZM/VXlJIvpDENIs9cIyPfjXZMhg1/ICqW/ johnson@agenix-recovery";
  systems = [
    oldman

    recovery_key
  ];
in {
  "git-credentials.age".publicKeys = systems;
  "github-copilot-hosts.age".publicKeys = systems;
}
