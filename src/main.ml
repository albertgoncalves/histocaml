module L = List
module P = Printf
module S = String

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

type 'a count = ('a * int)

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

let show_list (f : 'a -> string) : 'a list -> string =
    P.sprintf "\t#\n---------\n%s" |. S.concat "\n" |. L.rev_map f

let hist_to_string (f : 'a -> string) (xs : 'a count) : string =
    let (x, n) = xs in
    P.sprintf "%s\t%d" (f x) n

let read_line () : string option =
    try Some (input_line stdin) with End_of_file -> None

let read_lines : (unit -> string list) =
    let rec loop (accu : string list) : (string option -> string list) =
        function
            | Some x -> loop (x::accu) (read_line ())
            | None -> accu in
    loop [] |. read_line

let unpack (xs : 'a count) : int =
    let _, n = xs in
    n

let compare_hist (a : 'a count) (b : 'a count) : int =
    compare (unpack a) (unpack b)

let main =
    print_endline
    |. show_list @@ hist_to_string (fun x -> x)
    |. L.fast_sort compare_hist
    |. histogram
    |. read_lines

let () = main ()
