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

        # Provides a script that copies required file to ~/
        sometoolSetupScript =
          let
            registriesConf = pkgs.writeText "registries.conf" ''
              [registries.search]
              registries = ['docker.io']
              [registries.block]
              registries = []
            '';
          in
          pkgs.writeShellScriptBin "sometool-setup-script" ''
            #!${pkgs.runtimeShell}
            # Dont overwrite customised configuration
            if ! test -f ~/.config/sometool/registries.conf; then
              install -Dm555 ${registriesConf} ~/.config/sometool/registries.conf
            fi
          '';
      in
      {
        packages.mywrapper = import ./wrapper.nix {
          pkgs = pkgs;
        };
        defaultPackage = self.packages.${system}.mywrapper;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            self.defaultPackage.${system}

            #self.${system}.inputs.podman-rootless
           # Not trow error, but podman does not work
           #self.inputs.podman-rootless
           #self.inputs.podman-rootless.defaultPackage.${system}
           #self.inputs.podman-rootless.${system}.defaultPackage

           #self.inputs.podman-rootless.${system}
           #self.inputs.podman-rootless.x86_64-linux

            #self.inputs.${system}.podman-rootless
            #self.inputs.x86_64-linux.podman-rootless

            testScriptInFlake
            sometoolSetupScript

            hello.defaultPackage.${system}
          ];
          shellHook = ''
            #echo "Entering the nix devShell"
            test_script_in_flake
            sometool-setup-script
            test_script
          '';
        };
      });
}
