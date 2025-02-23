{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = import nixpkgs {
        inherit system;
      };
        geyser = (with pkgs;
          stdenv.mkDerivation {
            pname = "geyser";
            version = "1.0";
            src = fetchurl {
              url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone";
              hash = "sha256-Cut0XVe/S9/k1MeYuvGmrQHHNWeJ3V1Wu6xzrHDgqH8=";
            };
            phases = ["installPhase"];
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/Geyser-Standalone.jar
            '';
          }
        );
      in rec {
        defaultApp = flake-utils.lib.mkApp {
          drv = defaultPackage;
        };
        defaultPackage = geyser;
      }
    );
}
