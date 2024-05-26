{ pkgs }:
let
  rust-bin = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-analyzer" ];
  };
in pkgs.stdenv.mkDerivation {
  name = "rust-analyzer-wrap";

  src = ./.;

	phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  nativeBuildInputs = [ rust-bin ];

  unpackPhase = "";
  patchPhase = "substituteAllInPlace rust-analyzer-wrap.rs";

  buildPhase = ''
    mkdir -p $out/bin
    ${rust-bin}/bin/rustc rust-analyzer-wrap.rs -o $out/bin/rust-analyzer-wrap
  '';
}