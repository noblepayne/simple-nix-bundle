# What
A stupid simple "bundler" that produces a standalone executable for a nix derivation.

# Why
I wanted a simple method to run a shell script in CI that could leverage nixpkgs for dependencies. For some use cases these dependencies rarely change, so installing them every time in CI is a bit of a waste. Docker would be a fine solution to this for CI systems that easily allow custom images, however this requires hosting the image somewhere. Pre-compiling the script into a standalone executable allows me to store the file alongside the repo without any additional infrastructure. As long as the CI system can clone the repo, and allows creating/modifying `/nix`, this should work.

# Why Not
- Better bundlers exist (see nix-bundle, other utils in nixpkgs).
- Requires permission to write to the nix store.
- One can just use nix in CI.
- One can use nix to build a docker container with the required dependencies.

# Example
```bash
$ nix repl
Welcome to Nix 2.18.2. Type :? for help.
# Load simple-nix-bundle flake.
nix-repl> simpleNixBundle = builtins.getFlake("github:noblepayne/simple-nix-bundle") 
# Setup nixpkgs and pkgs
nix-repl> nixpkgs = builtins.getFlake("nixpkgs")                                     
nix-repl> system = "x86_64-linux"  # as an example                                                    
nix-repl> pkgs = nixpkgs.legacyPackages."${system}"                                  
# Use callPackage to create a bundler for your system and pkgs.
nix-repl> bundle = pkgs.callPackage simpleNixBundle.lib.mkBundler {}
# Call bundle to create a bundle derivation.
nix-repl> bundle_drv = bundle pkgs.htop "${pkgs.htop}/bin/htop"
nix-repl> bundle_drv
«derivation /nix/store/07np2li16rfwlqml02qjzbpbirrk5qk0-bundle.drv»
# Build that derivation.
nix-repl> :b bundle_drv
This derivation produced the following outputs:
  out -> /nix/store/cb9sxmi9g1if1v493czdqs0zhi32jnsa-bundle
nix-repl> CTRL+D
# Show final built script.
$ head /nix/store/cb9sxmi9g1if1v493czdqs0zhi32jnsa-bundle
#!/usr/bin/env sh
set -e
cat $0 | tail -n +6 | tar xzf - -P
/nix/store/az9rcmyxwgzry7zhjwgqfacbi8mxpf9w-htop-3.3.0/bin/htop
exit $?
�=ko�H���_ѷ��$Qo˓<X_&3k\2       ƞp��"[R��e7-�����to�գ��e=EI�"fbIlVWWWWWUW
...
