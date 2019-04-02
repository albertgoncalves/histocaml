# histocaml

This tool will return the frequency of the lines you give it via `stdin`. If you can break some elements into lines, this tool will count them for you.

Needed things
---
  * [Nix](https://nixos.org/nix/)

Quick start
---
```
$ nix-shell
[nix-shell:~/histocaml]$ ./make
[nix-shell:~/histocaml]$ ./example
```

---
This ritual is more or less the same as the above incantation.
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
COUNT   ELEM
8       1
4       c
2       abc
1       ab

[nix-shell:~/histocaml]$ ./make && cat example.txt | ./hist -b -d ";"
COUNT;ELEM
4;c
2;abc
1;ab
8;1
```

