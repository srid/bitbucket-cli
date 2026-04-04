{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "bkt";
          version = "0.16.4-bearer";
          src = ./.;
          vendorHash = "sha256-TXPNWBxcdkqw4BOueJ6lKK6HtTl/G6s9hfPz47Hgzfg=";
          subPackages = [ "cmd/bkt" ];
          ldflags = [ "-s" "-w" ];
          tags = [ "netgo" ];
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/bkt";
        };
      });
}
