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
ELEM,COUNT,PCT,HIST
1,8,0.5333,**************************
c,4,0.2667,*************
abc,2,0.1333,******
ab,1,0.0667,***
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

[nix-shell:~/histocaml]$ cat example.txt | ./hist | csvlook
| ELEM | COUNT | PCT    | HIST                       |
| ---- | ----- | ------ | -------------------------- |
| 1    | 8     | 0.5333 | ************************** |
| c    | 4     | 0.2667 | *************              |
| abc  | 2     | 0.1333 | ******                     |
| ab   | 1     | 0.0667 | ***                        |

[nix-shell:~/histocaml]$ cat example.txt | ./hist -b -d ";"
ELEM;COUNT;PCT;HIST
c;4;0.2667;*************
abc;2;0.1333;******
ab;1;0.0667;***
1;8;0.5333;**************************

[nix-shell:~/histocaml]$ eval/shuffle 1 100 | ./hist | csvlook
| ELEM    | COUNT | PCT    | HIST |
| ------- | ----- | ------ | ---- |
| 1 2 4 3 | 8     | 0.0800 | **** |
| 3 4 2 1 | 8     | 0.0800 | **** |
| 4 1 3 2 | 7     | 0.0700 | ***  |
| 1 3 2 4 | 6     | 0.0600 | ***  |
| 4 2 1 3 | 6     | 0.0600 | ***  |
| 1 2 3 4 | 5     | 0.0500 | **   |
| 2 1 3 4 | 5     | 0.0500 | **   |
| 2 4 3 1 | 5     | 0.0500 | **   |
| 3 4 1 2 | 5     | 0.0500 | **   |
| 1 4 3 2 | 4     | 0.0400 | **   |
| 2 3 4 1 | 4     | 0.0400 | **   |
| 2 4 1 3 | 4     | 0.0400 | **   |
| 3 1 2 4 | 4     | 0.0400 | **   |
| 3 1 4 2 | 4     | 0.0400 | **   |
| 3 2 4 1 | 4     | 0.0400 | **   |
| 4 2 3 1 | 4     | 0.0400 | **   |
| 4 3 2 1 | 4     | 0.0400 | **   |
| 1 3 4 2 | 3     | 0.0300 | *    |
| 1 4 2 3 | 3     | 0.0300 | *    |
| 2 3 1 4 | 2     | 0.0200 | *    |
| 3 2 1 4 | 2     | 0.0200 | *    |
| 4 3 1 2 | 2     | 0.0200 | *    |
| 2 1 4 3 | 1     | 0.0100 |      |
```
