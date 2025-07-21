FROM nixos/nix:latest

ENV NIX_CONFIG="experimental-features = nix-command flakes"
ENV NIX_PATH="https://github.com/NixOS/nixpkgs/archive/6b4955211758ba47fac850c040a27f23b9b4008f.tar.gz"
ENV HOME="/root"
ENV TERM="xterm-256color"

WORKDIR $HOME

RUN nix profile add \
	nixpkgs#bash \
	nixpkgs#bat \
	nixpkgs#direnv \
	nixpkgs#fd \
	nixpkgs#flyctl \
	nixpkgs#fzf \
	nixpkgs#gawk \
	nixpkgs#gcc \
	nixpkgs#gh \
	nixpkgs#git \
	nixpkgs#gnumake \
	nixpkgs#gnused \
	nixpkgs#htop \
	nixpkgs#neovim \
	nixpkgs#ripgrep \
	nixpkgs#starship \
	nixpkgs#tmux \
	nixpkgs#tree \
	nixpkgs#unzip \
	nixpkgs#zoxide

COPY workspace/ .

# Install tmux plugins via tpm
RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Install neovim plugins via Lazy
RUN nvim --headless "+Lazy! sync" +qa

ENTRYPOINT ["sleep", "infinity"]
