# OCaml pour les nuls

Ce projet est un cours indépendant du langage fonctionnel `OCaml`, ce cours
existe car l'enseignement de ce langage qu'on a reçu à la fac était absolument
horrible (on a jamais compilé un programme, juste bidouillé un repl !!). OCaml
étant un de mes langages préférés, je prends du temps pour transformer cette
fiche de révisions pour mes potes en un cours complet du langage. Je vais
globalement ignorer l'aspect impératif et objet du langage pour me concentrer sur
l'aspet fonctionnel. Ce cours par du principe que l'on sait déjà coder dans un
langage impératif, et qu'on cherche à apprendre un premier langage fonctionnel.
Je vais aussi présenter des notions qui ne seront pas vu par les élèves de la fac
où j'étais, mais que je trouve primordiales (comme les modules, la composition
de fonctions et les monads)

D'autre bonnes ressources pour apprendre ce langage sont :

- [Real World OCaml](https://dev.realworldocaml.org/)
- [Un autre cours alternatif d'une ancienne élève](https://ocaml.gelez.xyz/)

Bien que je trouve que le premier peut être difficile à suivre, et que le second
pourrait aller plus loin, elles restent de très bonnes ressources, conçus avec
amour par des individus compétants, et je vous encorage fortement à y jeter un
œuil. Je fais ce cours parce que j'espère pouvoir apporter d'autres choses, mais
surtout parce que c'est fun (:

La structure du cours est la suivante : Il y a un dossier par chapitre, chaque
dossier comporte un fichier `cours.md` qui contient le cours de ce chapitre et
un fichier `main.ml`, qui est un fichier qu'on peut importer dans un projet `dune`
qui utilise toutes les notions vues pendant le cours, pour pouvoir les tester facilement.

Le chapitre 0 détaille un peu plus les prérequis pour ce cours (je vous encourage
à le lire), et ce fichier readme sert de 'fiche de révision', qui récapitule vite
fait les notions vu pendant ce cours.

---
# Table des matières

1. [Les bases](#1-les-bases)
2. [Définitions locales et pattern matching](#2-définitions-locales-et-pattern-matching)
3. [Types de données customs](#3-types-de-données-customs)

---

# 1. Les bases

Point d'entrée du programme : `let () = <expression>`

Les types de données de base :

```
+--------+----------------------+----------------------+-----+
| Nom    | Description          | Operateurs           | fmt |
+========+======================+======================+=====+
| int    | nombre entiers       | +  -  *  /  **  ~- % | %d  |
| float  | nombre à virgule     | +. -. *. /. **. ~-.  | %g  |
| bool   | true / flase         | ||  &&  not          | %b  |
| char   | un caractère: 'a'    | <rien>               | %c  |
| string | chaîne de caractères | ^ (concaténation)    | %s  |
| unit   | (ne renvoie rien)    | <rien>               |     |
+--------+----------------------+----------------------+-----+
```

Définir une variable :

```ocaml
(* syntaxe : let <nom_variable>: <type> = <valeur> *)
let x: int = 42
let y: float = 16.5
let z = 23.75  (* le type peut être inféré *)
```

Définir une fonction :

```ocaml
(* syntaxe: let <nom_fn> <args> : <type_sortie> = <expr> *)
(* les arguments sont de la forme (<nom_arg>: type),
   ou juste <nom_arg> si leur type est inféré *)
let double (n: int): int = n * 2

(* On peut inférer chaque argument et sortie de fonction indépendemment *)
let moyenne a b: float = (a +. b) /. 2.  (* 2. = 2.0 *)

(* Pour les fonctions sans arguments, il faut préciser `()` en argument *)
let message () = printf "Ceci est mon tout premier programme OCaml !!\n"
```

Appeler une fonction :

```ocaml
(* syntaxe : <nom_fonction> puis les arguments séparés par des espaces *)
(* attention aux parenthèses pour l'ordre d'évaluation des arguments *)
let foo = moyenne (y * 2) z
let () = message ()
```

Utilisez le point-virgule pour séparer des expressions qui renvoient `unit` :

```ocaml
let () =
	message ();
	printf "%g\n" (moyenne (y * 2) z)
```

Conditions avec `if` :

```ocaml
(* Syntaxe : if <condition> then <expr_true> else <expr_false> *)
let signe_entier n =
    if n = 0
    then "Zéro"
    else if n > 0
        then "Positif"
        else "Négatif"
(* Non, y'a pas de elif, en OCaml *)
```

---

# 2. Définitions locales et pattern matching

Décomposition de valeurs :

```ocaml
(* Une variable qui contient un tuple (ensemble fini et ordonné de valeurs) *)
let horraire_alarme = (6, 30, 00)  

(* Tuple de variables de la même taille que la valeur à décomposer, avec les 
   valeurs à ignorer nommés `_`, ou préfixé par un `_` *)
let (alarme_heure, _alarme_minute, _) = horraire_alarme
```

Déclaration locales :

```ocaml
(* Syntaxe : let <declr_1> = <expr_1> and ... and <declr_n> = <expr_n> in <expr_suivante>
   Il peut y avoir autant de `and` qu'on veut, y compris 0 *)
let horraire_valide (heures, minutes, secondes) =
	let in_range borne_min borne_max valeur =
		borne_min <= valeur && valeur < borne_max
	in
	let sous_limite limite valeur = in_range 0 limite valeur in
	sous_limite 24 heures
	&& sous_limite 60 minutes
	&& sous_limite 60 secondes
```

Match-expressions :

```ocaml
(* Syntaxe: `match <expr> with`, puis pour chaque branche du match :
   | <pattern_1> | ... | <pattern_n> -> <expr_associé>, ou
   | <pattern_1> when <condition>    -> <expr_associé> *)
let signe_entier n =
	match n with
	| 0            -> "Zéro"     (* quand n = 0 *)
	| n when n > 0 -> "Positif"  (* quand n ≠ 0, mais est positif *)
	| _            -> "Négatif"  (* dans tous les cas restants (ici n < 0) *)
```

---

# 3. Types de données customs

Signature d'un tuple :

```ocaml
(* syntaxe : <type_1> * … * <type_n> *)
let origine: int * int = (0, 0)
```

Définir un type :

```ocaml
(* syntaxe : type <parametres> <nom_type> = … *)

(* type alias *)
type point = int * int

(* enum : *)
type actions =
	| Avancer of int  (* cette variante va encapsuler un int *)
	| Gauche
	| Droite

(* struct : *)
type robot = {
	nom: string;
	position: point;
}

(* GADTs : *)
type 'a option =
	| Some of 'a
	| None
```

Matcher un enum :

```ocaml
let effectue_action (action: actions) (r: robot) =
	match action with
	| Avancer n_cases -> aller_tout_droit n_cases r
	| Gauche -> tourner_gauche r
	| Droite -> tourner_droite r
```

Opérations sur un struct :

```ocaml
let tourner_droite (r: robot) =
	let { orientation; _ } = r in  (* décomposition avec field punning *)
	let nouvelle_orientation =
		match orientation with
		| Nord  -> Est
		| Est   -> Sud
		| Sud   -> Ouest
		| Ouest -> Nord
	in { r with orientation = nouvelle_orientation }  (* update fonctionnel *)
```
