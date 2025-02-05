{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.bun
            pkgs.chezmoi
            pkgs.clang
            pkgs.curl
            pkgs.direnv
            pkgs.eza
            pkgs.fzf
            pkgs.git
            pkgs.neovim
            pkgs.nixfmt-rfc-style
            pkgs.nodejs_22
            pkgs.rustup
            pkgs.starship
            pkgs.zoxide
          ];

          homebrew = {
            enable = true;
            onActivation.cleanup = "uninstall";
            taps = [
            ];
            brews = [
              "zsh-vi-mode"
              "zsh-autosuggestions"
            ];
            casks = [
              "1password"
              "1password-cli"
              # "bitwarden"
              "ghostty"
              "keybase"
              "mullvadvpn"
              "raycast"
              "zen-browser"
            ];
            masApps = {
              slack = 803453959;

              # useful for debugging macos key codes
              #key-codes = 414568915;
            };
          };

          # Add change default browser
          security.pam.enableSudoTouchIdAuth = true;

          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToEscape = true;

          system.defaults = {
            # Add swap caps for esc
            dock.autohide = true;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            loginwindow.LoginwindowText = "Erik's M1";
            screencapture.location = "~/Pictures/screenshots";
            screensaver.askForPasswordDelay = 0;
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          programs.zsh.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Eriks-MacBook-Air
      darwinConfigurations."Eriks-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
