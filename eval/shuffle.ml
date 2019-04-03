module L = List
module R = Random
module S = String
module Y = Sys

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let rec shuffle : ('a list -> 'a list) = function
    | [] -> []
    | [x] -> [x]
    | xs ->
        let (before, after) = L.partition (fun _ -> R.bool ()) xs in
        L.rev_append (shuffle before) (shuffle after)

let show_list (f : 'a -> string) : ('a list -> string) =
    S.concat " " |. L.rev_map f

let print_shuffle : (int list -> unit) =
    print_endline
    |. show_list string_of_int
    |. shuffle

let rec repeat (n : int) (f : unit -> unit) : unit =
    if n <= 0 then
        ()
    else
        (fun _ -> repeat (n - 1) f) @@ f ()

let main () =
    begin
        begin
            fun _ ->
                repeat
                    (int_of_string Y.argv.(2))
                    (fun () -> print_shuffle [1; 2; 3; 4])
        end
        |. R.init
        |. int_of_string
    end Y.argv.(1)

let () = main ()
