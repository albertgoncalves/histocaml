# histocaml

This tool will return the frequency of the lines you give it via `stdin`. If you can break some elements into lines, this tool will count them for you.

Needed things
---
  * [Nix](https://nixos.org/nix/)

Quick start
---
`./make` and `./example` are just shortcuts to:
```
$ nix-shell
[nix-shell:~/histocaml]$ ocamlopt src/main.ml -o hist
[nix-shell:~/histocaml]$ cat example.txt
c
1
1
abc
1
1
abc
c
c
1
c
1
ab
1
1

[nix-shell:~/histocaml]$ cat example.txt | ./hist
        #
---------
1       8
c       4
abc     2
ab      1
```
