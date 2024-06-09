{ lib
, fetchFromBitbucket
, makeDesktopItem
, buildPythonApplication
, bash
, cycler
, darkdetect
, dill
, ezdxf
, fonttools
, freetype-py
, gdal
, kiwisolver
, lxml
, matplotlib
, numpy
, ortools
, pikepdf
, pyopengl
, pyppeteer
, pyqt6
, pyserial
, python-dateutil
, qrcode
, rasterio
, reportlab
, rtree
, setuptools
, shapely
, simplejson
, six
, svg-path
, svglib
, vispy
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "FlatCAM_beta";
  version = "unstable-2024-03-22";

  src = fetchFromBitbucket {
    owner = "marius_stanciu";
    repo = pname;
    # branch = "Beta_8.99;
    rev = "260b77c44a14bfc9a8c42c5696c2e7e2dddf74c4"; # beta branch as of 2024-03-22
    hash = "sha256-CKBLLwGCAJzxMUDDiPJhGV1W0V72OsqWHpDBIAwadEU=";
  };

  format = "other";

  dontBuild = true;

  buildInputs = [ bash python3 ];
  nativeBuildInputs = [ bash python3 ];

  propagatedBuildInputs = [
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
    vispy
  ];

  preInstall = ''
    patchShebangs --host .
    patchShebangs --host assets/linux/flatcam-beta
    mkdir -p $out/share/{flatcam,applications}
  '';

  installFlags = [
    "USER_ID=0"
    "LOCAL_PATH=/build/source/."
    "INSTALL_PATH=${placeholder "out"}/share/flatcam"
    "APPS_PATH=${placeholder "out"}/share/applications"
  ];

  installPhase = ''
    cp -rf . $out
    mkdir -p $out/bin
    ln -s $out/assets/linux/flatcam-beta $out/bin/
    patchShebangs --host $out/assets/linux/flatcam-beta
    sed -i "s|python3|${python3.withPackages (_: propagatedBuildInputs)}/bin/python3|" $out/bin/flatcam-beta
    sed -i "s|script_path=.*|script_path=$out|" $out/bin/flatcam-beta
    sed -i "s|python_script_path=.*|python_script_path=$out|" $out/bin/flatcam-beta
    substituteInPlace $out/bin/flatcam-beta --replace "FlatCAM.py" "flatcam.py" 
  '';

  postInstall = ''
    # substitueInPlace \
    #   --replace "python3" "$python3/bin/python3"
    #   $out/bin/flatcam-beta 
    # mv $out/bin/flatcam{-beta,}
  '';

  desktopItems = makeDesktopItem {
    name = "flatcam_beta";
    desktopName = "FlatCAM Beta 8.995";
    exec = "flatcam_beta";
    type = "Application";
    terminal = true;
  };

  meta = with lib; {
    description = "2-D post processing for PCB fabrication on CNC routers";
    homepage = "https://bitbucket.org/marius_stanciu/flatcam_beta";
    license = licenses.mit;
    maintainers = with maintainers; [ "coldelectrons" ];
  };
}
