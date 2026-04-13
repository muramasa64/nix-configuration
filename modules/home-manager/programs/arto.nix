{ config, pkgs, inputs, ... }:
let
  artoFixed =
    inputs.arto.packages.${pkgs.system}.default.overrideAttrs (old: {
      installPhase = ''
        runHook preInstall

        app_path="$(find target/dx -maxdepth 6 -type d -name 'Arto.app' | head -n 1)"

        if [[ -z "$app_path" ]]; then
          echo "Error: Arto.app not found under target/dx"
          find target/dx -maxdepth 8 -type d || true
          exit 1
        fi

        mkdir -p $out/Applications
        cp -r "$app_path" $out/Applications/

        mkdir -p $out/bin
        ln -s "$out/Applications/Arto.app/Contents/MacOS/arto" "$out/bin/arto"

        runHook postInstall
      '';
    });
in
{
  home.packages = [
    artoFixed
  ];
}
