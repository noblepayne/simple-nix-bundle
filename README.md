# What
A stupid simple "bundler" that produces a standalone executable for a nix derivation.

# Why
I wanted a simple method to run a shell script in CI that could leverage nixpkgs for dependencies. For some use cases these dependencies rarely change, so installing them every time in CI is a bit of a waste. Docker would be a fine solution to this for CI systems that easily allow custom images, however this requires hosting the image somewhere. Pre-compiling the script into a standalone executable allows me to store the file alongside the repo without any additional infrastructure. As long as the CI system can clone the repo, and allows creating/modifying `/nix`, this should work.

# Why Not
- Better bundlers exist (see nix-bundle, other utils in nixpkgs).
- Requires permission to write to the nix store.
- One can just use nix in CI.
- One can use nix to build a docker container with the required dependencies.
