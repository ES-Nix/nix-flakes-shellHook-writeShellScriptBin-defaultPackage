{ pkgs ? import <nixpkgs> { } }:
let
  #pkgs = pkgs;

in pkgs.writeShellScriptBin "test_script" ''
    #!${pkgs.runtimeShell}
     echo 'Hi!'
''

