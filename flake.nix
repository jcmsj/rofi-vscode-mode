{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages.default =
        let
          toolchain = fenix.packages.${system}.minimal.toolchain;
          pkgs = nixpkgs.legacyPackages.${system};
          lib = pkgs.lib;
          rustPlatform = pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          };
        in
        rustPlatform.buildRustPackage rec {
          pname = "rofi-vscode-mode";
          version = "0.6.2";
          nativeBuildInputs = with pkgs; [
            pkg-config
            autoPatchelfHook
          ];
          buildInputs = with pkgs; [
            glib
            cairo
            pango
            sqlite
          ];
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          meta = {
            description = "A Rofi mode to open Visual Studio Code workspaces";
            homepage = "https://github.com/fuljo/rofi-vscode-mode";
            license = lib.licenses.mit;
            maintainers = [ ];
          };
        };
    });
}
