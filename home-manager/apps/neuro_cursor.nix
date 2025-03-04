{ stdenvNoCC, lib, ... }:
# let
# in 
stdenvNoCC.mkDerivation rec {
  pname = "neuro-cursor";
  version = "0.0.1";

  src = ./icons;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -v -r ./icons $out/share/icons
    runHook postInstall
  '';
}
