(* Labelled and Optional Arguments examples *)

(* Document with labels. Punning. Label different from name. Missing out labels. Boolean example. *)
let fill a s l v =
  for x = s to s + l - 1 do a.(x) <- v done

let filled () =
  let a = Array.make 100 "x" in
    fill a 20 40 "y";
    a

let fill a ~start:s ~length:l v =
  for x = s to s + l - 1 do a.(x) <- v done

let filled () =
  let a = Array.make 100 "x" in
    fill a ~start:20 ~length:40 "y";
    a

let filled () =
  let a = Array.make 100 "x" in
    fill a "y" ~length:20 ~start:40;
    a

let filled () =
  let a = Array.make 100 "x" in
    let st = 20 in
      let ln = 40 in
        fill a ~start:st ~length:ln "y";
        a

let fill a ~start ~length v =
  for x = start to start + length - 1 do a.(x) <- v done

let filled () =
  let a = Array.make 100 "x" in
    let start = 20 in
      let length = 40 in
        fill a ~start ~length "y";
        a

(* Commute arguments for partial application. *)

let divide x y = x / y

let f = divide 10000 

let _ = [f 100; f 50; f 20]

let divide ~x ~y = x / y

let f = divide ~x:10000 

let _ = [f 100; f 50; f 20]

let f = divide ~y:10000 

let _ = [f 100000; f 10000; f 1000]

(* Optional arguments and their role in extending APIs. *)
let take l n =
  if n < 0 then raise (Invalid_argument "take") else
    let rec take_inner r l n =
      if n = 0 then List.rev r else
        match l with
        | [] -> raise (Invalid_argument "take")
        | h::t -> take_inner (h::r) t (n - 1)
    in
      take_inner [] l n

let rec drop_inner n = function
  | [] -> raise (Invalid_argument "drop")
  | _::t -> if n = 1 then t else drop_inner (n - 1) t

let drop l n =
  if n < 0 then raise (Invalid_argument "drop") else
  if n = 0 then l else
    drop_inner n l
 
let rec split l =
  match l with
    [] -> []
  | h::t -> [h] :: split t

let rec split ~chunksize l =
  try
    take l chunksize :: split ~chunksize (drop l chunksize)
  with
    _ -> match l with [] -> [] | _ -> [l]

let rec split ?(chunksize=1) l =
  try
    take l chunksize :: split ~chunksize (drop l chunksize)
  with
    _ -> match l with [] -> [] | _ -> [l]

let rec split ?chunksize l =
  let ch =
    match chunksize with None -> 1 | Some x -> x
  in
    try
      take l ch :: split ~chunksize:ch (drop l ch)
    with
      _ -> match l with [] -> [] | _ -> [l]

(* The Standard Library modules, StdLabels --> Array, List, String *)

(* Questions. Using and permuting labels. Optional arguments. Designing an API
 * for a complex function. What is the cost of options? Example of an
 * accumulator -- good style? *)

(* 1 *)
let make ~len ~elt =
  Array.make len elt

(* 2 *)
type start = Start of int

type length = Length of int

let fill a (Start s) (Length l) v =
  for x = s to s + l - 1 do a.(x) <- v done

let filled () =
  let a = Array.make 100 "x" in
    fill a (Start 20) (Length 40) "y";
    a

(* 3 *)

(* 4 *)
let sub b ~off ~len =
  Buffer.sub b off len

let blit src ~srcoff dst ~dstoff ~len =
  Buffer.blit src srcoff dst dstoff len

let add_substring b s ~ofs ~len =
  Buffer.add_substring b s ofs len

(* 5 *)
let rec map_inner a f l =
  match l with
    [] -> List.rev a
  | h::t -> map_inner (f h :: a) f t

let map f l = map_inner [] f l

let rec map ?(a = []) f l =
  match l with
    [] -> List.rev a
  | h::t -> map ~a:(f h :: a) f t
