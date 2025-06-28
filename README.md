# rofi-vscode-mode Nix Flake

A Nix flake for building [rofi-vscode-mode](https://github.com/fuljo/rofi-vscode-mode) - a Rofi mode to open Visual Studio Code workspaces.

## About

This repository contains only a Nix flake for building the rofi-vscode-mode project. The actual source code remains in the [original repository](https://github.com/fuljo/rofi-vscode-mode), and this flake fetches it as an input.

This pattern allows for:
- **Separation of concerns**: Build configuration is separate from source code
- **Version pinning**: Specific commits/tags can be pinned for reproducible builds
- **Easy maintenance**: Updates to the original project don't require changes here unless build dependencies change
- **Nix-first approach**: Provides a clean Nix interface without cluttering the upstream repository

## Usage

### Building

To build the package:

```bash
nix build
```

### Installing

To install the package to your profile:

```bash
nix profile install
```

### Running directly

To run without installing:

```bash
nix run
```

### Using in your system configuration

Add this flake as an input to your system flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rofi-vscode-mode = {
      url = "github:yourusername/rofi-vscode-mode";  # Update with your repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rofi-vscode-mode, ... }: {
    # In your system packages or home-manager
    environment.systemPackages = with pkgs; [
      rofi-vscode-mode.packages.${system}.default
      # ... other packages
    ];
  };
}
```

## Configuration

After installing, you can use rofi-vscode-mode by adding it to your rofi configuration. Refer to the [original project documentation](https://github.com/fuljo/rofi-vscode-mode) for configuration details.

## Flake Structure

This flake:
- Uses [fenix](https://github.com/nix-community/fenix) for the Rust toolchain
- Fetches source code from the original repository as a flake input
- Builds using `rustPlatform.buildRustPackage`
- Includes necessary system dependencies (glib, cairo, pango, sqlite)

## Updating

To update to a newer version of rofi-vscode-mode:

1. Update the source input to point to the desired commit/tag
2. Update the `cargoHash` if dependencies have changed
3. Update the `version` field to match

```bash
nix flake update  # Updates to latest commits
nix build         # Test the build
```

## Dependencies

The package requires the following system libraries:
- glib
- cairo  
- pango
- sqlite

These are automatically handled by the Nix build.

## License

This flake configuration is provided as-is. The rofi-vscode-mode project itself is licensed under the MIT License. See the [original repository](https://github.com/fuljo/rofi-vscode-mode) for details.
