{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    rofi-vscode-mode = {
      url = "github:fuljo/rofi-vscode-mode";
      flake = false; 
    };
  };

  outputs = { self, fenix, flake-utils, nixpkgs, rofi-vscode-mode }:
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
          version = "0.8.1";
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
          src = rofi-vscode-mode;
          cargoHash = "sha256-Dz4v4r+I63UgEHnrIVAFcq5dTOVEFQ+cbumK57BP9qw=";
          meta = {
            description = "A Rofi mode to open Visual Studio Code workspaces";
            homepage = "https://github.com/fuljo/rofi-vscode-mode";
            license = lib.licenses.mit;
            maintainers = [ ];
          };
        };
    });
}
