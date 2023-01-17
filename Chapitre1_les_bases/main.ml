open Base
open Stdio
open Poly

(* Définitions de variables simples *)
let x: int = 42
let y: float = 16.5
let z = 23.75  (* ici le type est inféré *)

(* Définition de fonctions *)
let double (n: int): int = n * 2

(* On peut inférer les arguments et la sortie de fonction indépendemment *)
let moyenne a b : float = (a +. b) /. 2.

(* Voir tout inférer quand c'est évident *)
let entier_est_pair n = n % 2 = 0

(* Renvoie la longueur de l'hypotenus d'un triangle rectangle,
   dont la longueur des deux autres côtés est donné *)
let pythagore (cote1: float) (cote2: float): float =
	Float.sqrt (cote1 **. 2. +. cote2 **. 2.)

(* Exemple de if, arguments et sortie inférés *)
let signe_entier n =
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
    printf "42 est-il pair : %b, et son double vaut %d\n" (entier_est_pair x) (double x);
    printf "La moyenne de 16.5 et 23.75 est %f\n" (moyenne y z);
    printf "La longueur de l'hypothenus du triangle comprenant y et z est %f\n" (pythagore 3. 4.);
    printf "Le signe de -7 est %s\n" (signe_entier (-7));
    assert_ue_bien_enseigne "Inf202"
