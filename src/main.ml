module A = Array
module L = List
module P = Printf
module S = String
module Y = Sys

type 'a count = ('a * int)
type param = Alpha | RevAlpha | Error | Reverse | Delimiter of string

let usage : string =
    "HistOCaml
tiny tool that tallies things (written in OCaml)

USAGE   hist [-a -b -r] [-d DELIMITER]
FLAGS   -a              sort output alphabetically
        -b              sort output reverse alphabetically
        -r              reverse default output
        -d DELIMITER    replace default delimiter (\\t) with given string
INPUT   stdin
OUTPUT  stdout"

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let uncurry (f : 'a -> 'b -> 'c) (ab : ('a * 'b)) : 'c =
    let (a, b) = ab in f a b

let read_line () : string option =
    try Some (input_line stdin) with End_of_file -> None

let read_lines : (unit -> string list) =
    let rec loop (accu : string list) : (string option -> string list) =
        function
            | Some x -> loop (x::accu) (read_line ())
            | None -> accu in
    loop [] |. read_line

let histogram : 'a list -> 'a count list =
    let rec loop (n : int) (accu : 'a count list) : 'a list -> 'a count list =
        function
            | [] -> []
            | [x] -> (x, n)::accu
            | x::(xx::_ as xs) ->
                if x = xx then
                    loop (n + 1) accu xs
                else
                    loop 1 ((x, n)::accu) xs in
    loop 1 [] |. L.fast_sort compare

let compare_hist (k : int) (a : 'a count) (b : 'a count) : int =
    k * compare (snd a) (snd b)

let show_hist (delimiter : string) (f : 'a -> string) : 'a list -> string =
    (P.sprintf "COUNT%sELEM\n%s" delimiter) |.  S.concat "\n" |. L.rev_map f

let hist_to_string (delimiter : string) (xs : string count) : string =
    let (x, n) = xs in P.sprintf "%d%s%s" n delimiter x

let args () : string list = L.tl @@ A.to_list Y.argv

let pipeline (delimiter : string) (f : 'a count list -> 'a count list)
    : (unit -> unit) =
    print_endline
    |. show_hist delimiter (hist_to_string delimiter)
    |. f
    |. histogram
    |. read_lines

let parse : (string list -> param list) =
    let rec loop accu = function
        | [] -> accu
        | "-a"::xs -> loop (Alpha::accu) xs
        | "-b"::xs -> loop (RevAlpha::accu) xs
        | "-r"::xs -> loop (Reverse::accu) xs
        | "-d"::x::xs -> loop (Delimiter x::accu) xs
        | _::xs -> loop (Error::accu) xs in
    loop []

let compare_param _ : (param -> int) = function
    | Error -> 2
    | Delimiter _ -> 1
    | _ -> 0

let select_delimiter : (param list -> (string * param list)) = function
    | (Delimiter x)::xs -> (x, xs)
    | xs -> ("\t", xs)

let control_panel (delimiter : string) : (param list -> unit) =
    let pipeline' = pipeline delimiter in
    function
        | Alpha::_ -> pipeline' (fun x -> x) ()
        | RevAlpha::_ -> pipeline' L.rev ()
        | Reverse::_ -> pipeline' (L.stable_sort @@ compare_hist @@ -1) ()
        (* NOTE: additional [-d ...] flags will throw an error! *)
        | Error::_ | (Delimiter _)::_ ->
            (fun _ -> exit 1) @@ print_endline usage
        | _ -> pipeline' (L.stable_sort @@ compare_hist 1) ()

let main : (unit -> unit) =
    uncurry control_panel
    |. select_delimiter
    |. L.stable_sort compare_param
    |. parse
    |. args

let () = main ()
