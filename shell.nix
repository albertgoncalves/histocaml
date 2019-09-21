{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "OCaml";
    buildInputs = [
        (with ocaml-ng.ocamlPackages_4_07; [
            ocaml
            findlib
            ocp-indent
            utop
        ])
    ] ++ (with python37Packages; [
        (csvkit.overridePythonAttrs (oldAttrs: {checkPhase = "true";}))
    ]);
    shellHook = ''
        if [ $(uname -s) = "Darwin" ]; then
            alias ls="ls --color=auto"
            alias ll="ls -al"
        fi
        alias csvlook="csvlook --no-inference"
    '';
}
