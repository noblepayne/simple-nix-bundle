{
  stdenv,
  writeClosure,
  writeTextFile,
}:
pkg: runCmd:
let
  baseRunScript = writeTextFile {
    name = "base-run";
    # Relies on host environment for:
    #   sh, cat, tail, tar
    text = ''
      #!/usr/bin/env sh
      set -e
      cat $0 | tail -n +6 | tar xzf - -P
      ${runCmd}
      exit $?
    '';
    executable = true;
  };
  tools = stdenv.mkDerivation {
    name = "tools";
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      tar czf $out -P -T ${writeClosure pkg}
    '';
  };
  bundle = stdenv.mkDerivation {
    name = "bundle";
    dontUnpack = true;
    dontBuild = true;
    dontPatchShebangs = true;
    installPhase = ''
      cat ${baseRunScript} ${tools} >> $out
      chmod +x $out
    '';
  };
in
bundle
