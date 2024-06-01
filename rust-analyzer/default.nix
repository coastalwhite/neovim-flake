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
    substituteInPlace rust-analyzer-wrap.rs \
      --replace-fail '@rust-analyzer@' '${rust-bin}/bin/rust-analyzer' \
      --replace-fail '@RUST_SRC_PATH@' '${rust-bin}/lib/rustlib/src/rust/library'
  '';

  buildPhase = ''
    mkdir -p $out/bin
    cat rust-analyzer-wrap.rs
    ${rust-bin}/bin/rustc rust-analyzer-wrap.rs -o $out/bin/rust-analyzer-wrap
  '';
}