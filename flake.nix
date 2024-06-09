{
  description = "Flatcam-beta 8.995 from bitbucket";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...} @ inputs:
  let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (sys: f nixpkgs.legacyPackages.${sys});
    # pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.python3Packages.callPackage ./default.nix {
        inherit (pkgs.python3Packages)
          cycler
          darkdetect
          dill
          ezdxf
          fonttools
          freetype-py
          gdal
          kiwisolver
          lxml
          matplotlib
          numpy
          ortools
          pikepdf
          pyopengl
          pyppeteer
          pyqt6
          pyserial
          python-dateutil
          qrcode
          rasterio
          reportlab
          rtree
          setuptools
          shapely
          simplejson
          six
          svg-path
          svglib
          vispy;
      };
    });

    # devShells = forAllSystems (system: {
    #   default = pkgsForEach.${system}.callPackage ./shell.nix {};
    # });

    # nixosModules.default = import ./module.nix inputs;
  };
}
