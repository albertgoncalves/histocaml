module A = Array
module L = List
module P = Printf
module S = String
module Y = Sys

type 'a count = ('a * int)

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let read_line () : string option =
    try Some (input_line stdin) with End_of_file -> None

let read_lines : (unit -> string list) =
    let rec loop (accu : string list) : (string option -> string list) =
        function
            | Some x -> loop (x::accu) (read_line ())
            | None -> accu in
    loop [] |. read_line

let histogram : 'a list -> 'a count list =
    let rec loop (n : int) (accu : 'a count list)
        : 'a list -> 'a count list =
        function
            | [] -> []
            | [x] -> (x, n)::accu
            | x::(xx::_ as xs) ->
                if x = xx then
                    loop (n + 1) accu xs
                else
                    loop 1 ((x, n)::accu) xs in
    loop 1 [] |. L.fast_sort compare

let unpack (xs : 'a count) : int = let _, n = xs in n

let compare_hist (a : 'a count) (b : 'a count) : int =
    compare (unpack a) (unpack b)

let show_list (f : 'a -> string) : 'a list -> string =
    P.sprintf "\t#\n---------\n%s" |. S.concat "\n" |. L.rev_map f

let hist_to_string (xs : string count) : string =
    let (x, n) = xs in P.sprintf "%s\t%d" x n

let args () : string list = A.to_list Y.argv

let pipeline (f : 'a count list -> 'a count list) : (unit -> unit) =
    print_endline
    |. show_list hist_to_string
    |. f
    |. histogram
    |. read_lines

let usage : string =
"HistOCaml
tiny tool that tallies things (written in OCaml)

FLAGS   -a or --a   sort output alphabetically
INPUT   stdin
OUTPUT  stdout"

let control_panel : (string list -> unit) = function
    | [_; "-a"] | [_; "--a"] -> pipeline (fun x -> x) ()
    | [_] -> pipeline (L.fast_sort compare_hist) ()
    | _ -> print_endline usage

let main = control_panel |. args

let () = main ()
