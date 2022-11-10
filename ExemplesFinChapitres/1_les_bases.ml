(* librairies utilisés : stdio *)
open Base
open Stdio

(* Définitions de variables simples *)
let x: int = 42
let y: float = 16.5
let z = 23.75  (* ici le type est inféré *)

(* Définition de fonctions *)
let double (n: int): int = n * 2

(* Fonction dont le type des arguments et de sortie sont inférés *)
let moyenne a b = (a +. b) /. 2.

(* Fonction sans argument, mais avec () pour éviter qu'elle soit évaluée direct *)
let message () = printf "Ceci est mon tout premier programme OCaml !!\n"

(* Point d'entrée du programme *)
let () =
    message ();
    printf "42 * 2 = %d\n" (double x);
    printf "La moyenne de 16.5 et 23.75 est %f\n" (moyenne y z)
