# https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# https://github.com/DeterminateSystems/nix-installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake .config/nix
darwin-rebuild switch --flake .config/nix
