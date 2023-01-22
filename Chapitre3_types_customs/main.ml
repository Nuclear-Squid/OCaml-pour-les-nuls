open Base
open Stdio
open Poly

(* La position (x, y) d'une case sur le terrain *)
type point = int * int

(* La translation d'une case à une autre, sur le terrain *)
type vecteur = int * int

(* Un intervalle {a, …, b}, tel que a <= b *)
type intervalle = int * int

let dimentions_terrain = (50, 50)

(* Quelques opérations simples sur les vecteurs *)
let translation_case (x1, y1: vecteur) (x2, y2: point): point = (x1 + x2, y1 + y2)
let vecteur_fois_int (x, y: vecteur) (n: int): vecteur = (x * n, y * n)

(* Vérifie qu'une valeur est compris dans un intervalle (bornes incluses *)
let compris_dans (a, b: intervalle) (n: int) = a <= n && n <= b

(* Les types 'a et 'b sont génériqueus et indépendants, aucunes restrictions entre eux *)
(* (les fonctions existent déjà dans Base, mais on les réimplémentent pour l'exemple) *)
let fst (x, _: 'a * 'b): 'a = x
let snd (_, y: 'a * 'b): 'b = y

(* Vérifie qu'une case est dans les limites du plateau *)
let est_dans_terrain (x, y: point): bool =
	let dim_x = fst dimentions_terrain / 2  (* on lit une constante globale *)
    and dim_y = snd dimentions_terrain / 2
    in
	compris_dans (-dim_x, dim_x) x && compris_dans (-dim_y, dim_y) y

(* ====<< Définition du robot >>==== *)
type point_cardinal = Nord | Sud | Est | Ouest

type robot = {
	nom: string;
	position: point;
	orientation: point_cardinal;
}

type actions =
	| Gauche
	| Droite
	| Avancer of int 

let tourner_gauche (r: robot) =
    let nouvelle_orientation =
        match r.orientation with
        | Nord  -> Ouest
        | Ouest -> Sud
        | Sud   -> Est
        | Est   -> Nord
    in { r with orientation = nouvelle_orientation }

let tourner_droite (r: robot) =
    let nouvelle_orientation =
        match r.orientation with
        | Nord  -> Est
        | Est   -> Sud
        | Sud   -> Ouest
        | Ouest -> Nord
    in { r with orientation = nouvelle_orientation }

let direction_vers_vecteur = function
    | Nord  -> ( 0,  1)
    | Ouest -> (-1,  0)
    | Sud   -> ( 0, -1)
    | Est   -> ( 1,  0)

let aller_tout_droit (distance: int) (r: robot): robot option =
    let deplacement = vecteur_fois_int (direction_vers_vecteur r.orientation) distance in
    let case_arrivee = translation_case deplacement r.position
    in
    if est_dans_terrain case_arrivee
    then Some { r with position = case_arrivee }
    else None

let effectue_action (action: actions) (r: robot): robot =
    match action with
    | Avancer n -> begin
        match aller_tout_droit n r with
        | Some new_curiosity -> new_curiosity
        | None -> failwith "Curiosity est sorti du terrain."
    end
    | Gauche -> tourner_gauche r
    | Droite -> tourner_droite r

let affiche_info_robot (r: robot) =
    let { nom; position = (pos_x, pos_y); orientation } = r in
    let str_direction = match orientation with
        | Nord  -> "nord"
        | Ouest -> "ouest"
        | Sud   -> "sud"
        | Est   -> "est"
    in
    printf "Position de %s : (%d, %d), direction : %s\n" nom pos_x pos_y str_direction

let () =
    let curiosity = {
        nom = "Curiosity";
        position = (0, 0);
        orientation = Est;
    }
    in
    affiche_info_robot curiosity;
    affiche_info_robot (
        effectue_action Gauche (
        effectue_action (Avancer 5) (
        effectue_action Droite curiosity
    )))
