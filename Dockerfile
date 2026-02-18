FROM nixos/nix:latest

ENV NIX_CONFIG="experimental-features = nix-command flakes"
ENV HOME="/root"
ENV TERM="xterm-256color"

WORKDIR $HOME

RUN nix profile add nixpkgs#busybox nixpkgs#git --priority 4

COPY flake.nix .
RUN nix profile add .#default

COPY workspace/ .

# Install tmux plugins via tpm
RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Install neovim plugins via Lazy
RUN nvim --headless "+Lazy! sync" +qa

ENTRYPOINT ["sleep", "infinity"]
