{
  description = "This is a nix flake package";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.podman-rootless.url = "github:ES-Nix/podman-rootless";
  inputs.hello.url = "github:GNU-ES/hello";

  outputs = { self, nixpkgs, flake-utils, podman-rootless, hello }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        #
        #pkgsAllowUnfree = import nixpkgs {
        #  system = "x86_64-linux";
        #  config = { allowUnfree = true; };
        #};

        testScriptInFlake = pkgs.writeShellScriptBin "test_script_in_flake" ''
          #!${nixpkgs.legacyPackages.${system}.stdenv.shell}
          echo 'From echo in flake.nix file'
        '';
      in
      {
        #packages.mywrapper = import ./wrapper.nix {
        #  pkgs = pkgs;
        #};
        #defaultPackage = self.packages.${system}.mywrapper;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Why does not work?
            #podman-rootless.packages.${system}.mypodman

            podman-rootless.defaultPackage.${system}
            testScriptInFlake
            hello.defaultPackage.${system}
          ];
          shellHook = ''
            # TODO: document why this.
            export TMPDIR=/tmp

            echo 'Entering the nix + flake devShell example!'

            test_script_in_flake
            sometool-setup-script
            hello
            podman-setup-script
            podman-capabilities
          '';
        };
      });
}
