{ fetchgit, gawk, socat, jq, lib, makeWrapper, slurp, stdenv, hyprland, bash, make }:

stdenv.mkDerivation rec {
  pname = "hyprevents";
  version = "unstable-2023-12-03";

  src = fetchgit {
    url = "https://github.com/vilari-mickopf/hyprevents.git";
    rev = "";
    sha256 = "";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ make ];

  #dontBuild = true;

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
