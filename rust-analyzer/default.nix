{ pkgs }:
let
  rust-bin = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-analyzer" "rust-src" ];
  };
in pkgs.stdenv.mkDerivation {
  name = "rust-analyzer-wrap";

  src = ./.;

	phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  nativeBuildInputs = [ rust-bin ];

  unpackPhase = "";
  patchPhase = ''
    RUST_SRC_PATH="${rust-bin}/lib/rustlib/src/rust/library"
    substituteAllInPlace rust-analyzer-wrap.rs
  '';

  buildPhase = ''
    mkdir -p $out/bin
    ${rust-bin}/bin/rustc rust-analyzer-wrap.rs -o $out/bin/rust-analyzer-wrap
  '';
}