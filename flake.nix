{
  outputs = inputs@{ ... }:
    (
      let
        mkBundler = import ./bundle.nix;
      in
      {
        lib = {
          inherit mkBundler;
        };
      }
    );
}
