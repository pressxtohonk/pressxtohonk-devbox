{
  description = "devbox environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    env = with pkgs; [
      # provided by base image
      # - bashInteractive
      # - git

      # devtools
      direnv
      gh
      neovim
      opencode

      # search
      fd
      fzf
      ripgrep

      # shell customization
      bat
      starship
      tmux
      zoxide

      # flyctl
      # gawk
      # gcc
      # gnumake
      # gnused
      # htop
      # pyright
      # ruff
      # tree
      # unzip
      # uv
    ];
  in {
    # to set up remote dev container
    packages.${system}.default = pkgs.buildEnv {
      name = "devbox-env";
      paths = env;
    };
    # to set up local dev shell
    devShells.${system}.default = pkgs.mkShell {
      name = "devbox-env";
      packages = env;
    };
  };
}
