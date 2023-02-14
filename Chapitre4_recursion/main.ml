open Base
open Stdio
open Poly

(* note : il faut préciser `rec` quand on défini une fonction récursive *)
let rec spam_message (n_messages: int) (message: string): unit =
	if n_messages <= 0  (* Condition d'arrêt *)
	then ()  (* Ne rien faire, ce qui arrête la récursion *)
	else begin
		printf "%s\n" message;  (* Traiter les paramêtres *)
		spam_message (n_messages - 1) message  (* Étape suivante *)
	end

let rec fac (n: int): int =
    if n <= 1  (* Condition d'arrêt *)
    then 1  (* arrêter la récursion en renvoyant 1 *)
    else n * fac (n - 1)  (* fac n dépends de la valeur de fac (n - 1) *)

(* Ne sait représenter que les entiers naturels *)
type peano =
    | Succ of peano (* contient Zero ou un autre Succ qui contiendra Zero ou… *)
    | Zero

(* transforme 2 en Succ (Succ Zero) *)
let rec peano_of_int (n: int): peano =
    if n <= 0
    then Zero
    else Succ (peano_of_int (n - 1))

(* transforme Succ (Succ Zero) en 2 *)
let rec peano_to_int = function
    | Zero -> 0
    | Succ p -> 1 + peano_to_int p

let rec affiche_liste_entier = function
    | [] -> ()
    | valeur :: suite -> begin
        printf "%d\n" valeur;
        affiche_liste_entier suite
    end

let rec make_range (borne_inf: int) (borne_sup: int): int list =
    if borne_inf > borne_sup
    then []
    else borne_inf :: make_range (borne_inf + 1) borne_sup

let somme_meme_signe (input: int list): int list =
    let meme_signe a b = a * b >= 0
	in
    let rec loop (acc: int) = function
        | [] -> []
        | [last] -> if meme_signe last acc
            then [acc + last]
            else [acc ; last]
        | hd :: tl -> if meme_signe hd acc
            then loop (hd + acc) tl
            else acc :: loop hd tl
    in
    loop 0 input

let () =
    spam_message 3 "OCaml <3 <3 <3";
    printf "5! = %d\n" (fac 5);
    printf "le successeur du successeur de zéro est %d\n" (peano_to_int (Succ (Succ Zero)));
    assert (Succ (Succ Zero) = peano_of_int 2);
    printf"\n";
    affiche_liste_entier (somme_meme_signe (-1 :: make_range 2 9 @ [-42; -69]))
