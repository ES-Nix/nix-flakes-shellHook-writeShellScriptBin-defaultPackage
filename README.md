# nix-flakes-shellHook-writeShellScriptBin-defaultPackage
Example of nix flakes shellHook writeShellScriptBin defaultPackage all together


First relevant commit:
`git checkout bec1cc291b192306388af7521fedb2ba37728bb7`

`nix develop github:ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage/9260e7ed15c91cc35c02bbdec1b1bff0c0931ec5`


Really cool state, podman works: `git checkout 9260e7ed15c91cc35c02bbdec1b1bff0c0931ec5`

```
git clone https://github.com/ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage.git
cd nix-flakes-shellHook-writeShellScriptBin-defaultPackage
```

```
nix \
develop \
github:ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage/5e43d777ac2de9987a462de6cf067fe73d898da6
```

```
nix \
develop \
github:ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage/65e9e5a64e3cc9096c78c452b51cc234aa36c24f \
--command \
podman \
run \
--interactive=true \
--tty=true \
alpine:3.13.0 \
sh \
-c 'uname --all && apk add --no-cache git && git init'
```

