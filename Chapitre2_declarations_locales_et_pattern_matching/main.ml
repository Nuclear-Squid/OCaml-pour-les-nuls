open Base
open Stdio
open Poly

(* Represente une heure au format heure, minute, seconde *)
let horraire_alarme = (6, 30, 00)

(* On décompose le tuple horraire_alarme en éléments simples *)
let (alarme_heure, alarme_minute, _) = horraire_alarme

(* Fait la somme de deux horraires, en respectant les bornes sur les champs *)
let ajoute_horraires horraire1 horraire2 =
    let (heures1, minutes1, secondes1) = horraire1
    and (heures2, minutes2, secondes2) = horraire2
    and div_euclidienne valeur diviseur = (valeur / diviseur, valeur % diviseur)
    in
    let min_en_plus, secondes = div_euclidienne (secondes1 + secondes2) 60 in
    let heures_en_plus, minutes = div_euclidienne (minutes1 + minutes2 + min_en_plus) 60 in
    let _, heures = div_euclidienne (heures1 + heures2 + heures_en_plus) 24
    in
    (heures, minutes, secondes)

(* Pas besoin de décompser alarme, car on veut juste la transmettre à ajoute_horarires *)
let snooze alarme = ajoute_horraires alarme (0, 5, 0)

(* On peut décomposer des valeurs valeurs passé en arguments directement dans
   la définition de la fonction *)
let affiche_horraire (heures, minutes, secondes) =
    printf "Horraire : %dh%d:%d.\n" heures minutes secondes

(* Les matchs peuvent décomposer une valeur et tester une égalité en même temps *)
let peut_dejeuner horraire =
	match horraire with
	| (12, _, _) -> true
	| _          -> false

(* exemple de match avec plusieurs patterns par branches *)
(* On cherche ici à vérifier si une date est valide *)
let date_valide (mois: int) (jour: int): bool = 
    let jour_valide borne_max jour : bool =
        1 <= jour && jour <= borne_max
    in 
    match mois with
    | 2                           -> jour_valide 28 jour
    | 4 | 6 | 9 | 11              -> jour_valide 30 jour
    | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> jour_valide 31 jour
    | _ -> false  (* mois invalide *) 

(* Une fonction du chapitre précédent, mais en mieux grace aux matchs ! *)
(* `function` permet d'avor du sucre syntaxique, c'est équivalent à 
   let signe_entier n = match n with … *)
let signe_entier = function
	| 0            -> "Zéro"
	| n when n > 0 -> "Positif"
	| _            -> "Négatif"

let () =
    printf "Le réveil va sonner à %dh%d.\n" alarme_heure alarme_minute;
    affiche_horraire (snooze horraire_alarme);
    printf "15h39 est une heure pour déjeuner ? %b\n" (peut_dejeuner (15, 39, 00));
    printf "La date 5-28 est-elle valide ? %b\n" (date_valide 5 28);
    printf "le signe de -7 est : %s\n" (signe_entier (-7))

