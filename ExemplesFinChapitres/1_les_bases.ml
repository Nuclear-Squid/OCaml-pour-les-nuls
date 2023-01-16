open Base
open Stdio
open Poly

(* Définitions de variables simples *)
let x: int = 42
let y: float = 16.5
let z = 23.75  (* ici le type est inféré *)

(* Définition de fonctions *)
let double (n: int): int = n * 2

(* Fonction dont seul les types des arguments sont inférés *)
let moyenne a b : float = (a +. b) /. 2.

let pythagore (cote1: float) (cote2: float): float =
	Float.sqrt (cote1 **. 2. +. cote2 **. 2.)

(* Fonction dont tous les types de données sont iférées *)
let double_si_pair n =
    if n % 2 = 0
    then double n
    else n

(* Exemple de elif *)
let signe_du_nombre n =
    if n = 0
    then "Zéro"
    else if n > 0
        then "Positif"
        else "Négatif"

(* La fonction failwith fait planter le programme avec le message d'erreur donné *)
let assert_ue_bien_enseigne (ue: string): unit =
    if String.lowercase ue = "inf201"
    then failwith "Non, l'ue inf201 est pas bien enseigne."

(* Fonction sans argument, mais avec () pour éviter qu'elle soit évaluée direct *)
let message () = printf "Ceci est mon tout premier programme OCaml !!\n"

(* Point d'entrée du programme *)
let () =
    message ();
    printf "42 est pair, donc 42 * 2 = %d\n" (double_si_pair x);
    printf "La moyenne de 16.5 et 23.75 est %f\n" (moyenne y z);
    printf "L'hypothenus du triangle yzt est %f\n" (pythagore 3. 4.);
    printf "Le signe de -7 est %s\n" (signe_du_nombre (-7));
    assert_ue_bien_enseigne "Inf202"
