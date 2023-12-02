{ fetchgit, gawk, socat, jq, lib, makeWrapper, slurp, stdenv, hyprland, bash }:

stdenv.mkDerivation rec {
  pname = "hyprevents";
  version = "unstable-2023-12-02";

  src = fetchgit {
    url = "";
    rev = "";
    sha256 = "";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -Dm755 wlprop.sh $out/bin/wlprop
    wrapProgram "$out/bin/wlprop" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ gawk jq slurp sway ]}"

    runHook postInstall
  '';
  passthru.scriptName = "hyprevents";

  meta = with lib; {
    description = "Invoke shell functions in response to Hyprland socket2 events";
    homepage = "https://github.com/vilari-mickopf/hyprevents";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "hyprevents";
  };
}
