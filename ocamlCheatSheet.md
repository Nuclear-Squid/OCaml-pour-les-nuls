# OCaml Cheat Sheet

---
## Table des matières

- [Types de données](#types-de-données)
    * [Types de données](#types-de-données)
    * [Caster un type dans un autre](#caster-un-type-dans-un-autre)
    * [Les opérateurs](#les-opérateurs)
- [Variables et fonctions](#variables-et-fonctions)
    * [Déclarer une variable](#déclarer-une-variable)
    * [Déclarer une fonction](#déclarer-une-fonction)
    * [Appeler une fonction](#appeler-une-fonction)
    * [Le double point-virgule (`;;`)](#le-double-point-virgule-)
    * [Le rôle des parenthèses dans les appels de fonctions](#le-rôle-des-parenthèses-dans-les-appels-de-fonctions)
    * [Sémantique de fonctions](#sémantique-de-fonctions)
- [Afficher un message dans la console](#afficher-un-message-dans-la-console)
- [Tests et conditions](#tests-et-conditions)
    * [Tests avec `if`](#tests-avec-if)
    * [Les match-expressions (ou pattern matching)](#les-match-expressions-ou-pattern-matching)
- [Composition de fonctions](#composition-de-fonctions)
    * [Le mot clé `in`](#le-mot-clé-in)
    * [Le simple point-virgule](#le-simple-point-virgule)
- [Types customs et structures de donnés avancés](#types-customs-et-structures-de-donnés-avancés)
    * [Les types synonymes](#les-types-synonymes)
    * [Les tuples (ou types produits)](#les-tuples-ou-types-produits)
    * [Les énumérés (ou types sommes)](#les-énumérés-ou-types-sommes)
    * [Associer une valeur a un constructeur](#associer-une-valeur-a-un-constructeur)
    * [Les inférences de types (ou polymorphie)](#les-inférences-de-types-ou-polymorphie)
    * [Les types récursifs](#les-types-récursifs)
- [Fonctions récursives](#fonctions-récursives)
---

## Types de données

### Types de données

- `int` (nombre entiers)
- `float` (nombre à virgule)
- `bool` (true / false)
- `char` (un seul caractère: 'a')
- `string` (une chaîne de caractères: "AAAAAA")
- `unit` (ne renvoie rien)

toujours faire très attentions au types utilisé.


### Caster un type dans un autre

```ocaml
float_of_int <int>      (* renvoie la même valeur mais en `float` *)
int_of_float <float>    (* renvoie la partie entière du float (entier arrondi en dessous) *)
string_of_int <int>     (* transforme un entier en une chaine de caractère *)
string_of_float <float> (* transforme un flotant en une chaine de caractère *)
```

### Les opérateurs

pour les int :

- `+` (addition)
- `-` (soustraction
- `*` (multiplication)
- `/` (division euclidienne)
- `mod` (reste de la division euclidienne)

pour les floats :

- `+.` (addition)
- `-.` (soustraction
- `*.` (multiplication)
- `/.` (division)
- `**` (puissance)

pour les bools :

- `||` (ou)
- `&&` (et)
- `not` (inverse la valeur du booléen)

comparaisons :

- `=` (est égal à)
- `<>` (est différent à)
- `>` (suppérieur)
- `>=` (suppérieur ou égal)
- `<` (inférieur)
- `<=` (inférieur ou égal)
- (ces opérateurs renvoient des boolées).

pour les strings : `^` pour concaténer les chaines (les mettre bout à bout).

---

## Variables et fonctions

### Déclarer une variable

syntaxe: `let <nom_de_la_variable> : <type> = <valeur>`

exemples :

```ocaml
let x : int = 69
let b : bool = true
;;
```

remarque: une variable est une fonction sans argument qui renvoie une constante, c'est pour ça qu'on ne peut pas modifier la valeur d'une variable en OCaml.

### Déclarer une fonction

syntaxe: `let <nom_de_la_fonction> <arguments> : <type_de_sortie> = <expression>`

pour chaque argument, on fait `(<nom_argument>: <type_argument>)`

le type de sortie est le type de la valeur renvoyée.

exemple :

```ocaml
let carre (x: float): float = x *. x
let estPair (x: int): bool = (x mod 2 = 0) (*mod : reste de la division euclidienne de deux entiers*)
let moyenne (x: float) (y: float): float = (x +. y) /. 2.0
let mesage: unit = Printf.printf "un message très utile \n%!"
;;
```

remarque : l'indentation et le retour à la ligne ne sont *techniquement* pas obligatoires mais sont très fortement conseillés pour rendre le programme plus lisible. On peut tout de même s'en passer quand la fonction est très simple (pas plus longue qu'une petite expression).

### Appeler une fonction

syntaxe : `<nom_de_la_fonction> <argument1> <argument2> ... <argumentn>`

appeler une fonction revient à utiliser une fonction prédéfinie, avec des variables donnés en entrée.

exemples :

```ocaml
carre 5.0           (* renvoie 25 *)
moyenne 12.5 16.5   (* renvoie 14.5 *)
message             (* renvoie rien, affiche "un message très utile" dans la console *)
```

### Le double point-virgule (`;;`)

le `;;` doit être utilisé après la dernière affectation. Il n'y a pas besoin de le mettre après chaque fin de ligne.

exemple :

```ocaml
(* Version moche *)
let x : float = 12.0;;
let y = carre x;;
let z = estPair y;;
Printf.printf "Fin des affectations.\n%!";;

(* Version propre *)
let x : float = 12.0
let y = carre x
let z = estPair y
;;
Printf.printf "Fin des affectations.\n%!"
```

### Le rôle des parenthèses dans les appels de fonctions

on utilise les parenthèses pour rendre explicite les cas où les variables ou fonctions passé en argument a une autre fonction sont ambiguës. exemple :

```ocaml
moyenne carre -12.0 carre 17.0
(*
- -12.0 est vu comme un calcul et non un nombre négatif
- carre, -12.0, carre et 17.0 sont tous passé comme argument à moyenne, qui n'en demande que 2
- puisque -12.0 et 17.0 sont passé à moyenne, les deux `carre` n'ont pas d'arguments.
*)
moyenne (carre (-12.0)) (carre 17.0) (* ici, les arguments sont valides *)
```

remarques :
- les parenthèses dans `moyenne (4.0) (5.0)` sont redondantes car l'expression n'est pas ambiguë.
- `moyenne (4.0 5.0)` va renvoyer une erreur car `4.0` et `5.0` sont vu comme un seul argument (voir tuples)


### Sémantique de fonctions

Les sémantiques sont les énormes commentaires qui expliquent comment une fonction fonctionne. Dans la vrai vie on fait pas ça mais puisque c'est demandé dans les compte-rendus on explique comment ça marche ici. La spécification explique ce que fait la fonction d'un point de vue très général, tandis que la réalisation s'attarde sur le détail du fonctionnement de la fonction.

syntaxe :

```ocaml
(*
    | SPÉCIFICATION
    | <nom_de_la_fonction> : <explicaton du rôle de la fonction>
    | - Profil : <nom_de_la_fonction> : <type_arg_1> -> <type_arg_2> -> ... -> <type_sortie>
    | - Sémantique : <nom_de_la_fonction> <nom_arg_1> <nom_arg_2> <explication de ce que fait la fonction>
    | - Exemple et propriétés :
    |   (a) <appel_fonction> = <sortie>
    |   (b) <propriété plus ou moins intéressante de la fonction>
    |
    | RÉALISATION
    | - Algorithme : Etape 1 (en français)
    |                Etape 2
    |                ...
    |                Etape n
    | - Implémentation :
*)
<le_reste_du_code> (*enfin*)

```

exemple :
```ocaml
(*
    | SPÉCIFICATION
    | dist : Distance à l'origine d'un point
    | - Profil : dist : R -> R -> R+
    | - Sémantique : dist x y renvoie la distance à l'origine du point de coordonnés (x, y)
    | - Exemple et propriétés :
    |   (a) dist 0 1 = 1
    |   (b) dist 3 4 = 5
    |   (c) dist x y >= 0 pour tout x, y réel
    |
    | RÉALISATION
    | - Algorithme : On applique le théorème de pythagore
    | - Implémentation :
*)
let dist (x: float) (y: float) : float = sqrt(x*x + y*y)
;;
```
---

## Afficher un message dans la console

syntaxe: `Printf.printf "message" <val1> ... <valn>`

Caractères utiles :

- `\n` revient à la ligne, souvent utilisé en fin de message.
- `%!` vide le buffer du print. Absolument **toujours** l'utiliser en fin de message. Ne pas le mettre veut dire ne jamais libérer la mémoire utilisé par le printf, donc de plus en plus de mémoire inutilement inutilisé après chaque printf. Non je sais pas pourquoi il faut le préciser.

Pour insérer une variable dans le message, on écrit `%<première_lettre_du_type>`, si vous chercher à afficher le contenu d'un tuple ou d'un énum, allez voir la section "Caster des tuples et enmums" du chapitre "Types customs et structures de donnés avancés". Les variables vont être inséré dans l'ordre dont elles sont entré entre les parenthèses.

`Printf.printf` est de type unit.

exemples :

```ocaml
Printf.printf "Hello World!\n%!"
Printf.printf "x = %f et b = %b\n%!" x b (* écrit dans le terminal "x = 42.12 et b = false" *)
Printf.printf "x = %f => x^2 = %f\n%!" x (carre x) (* écrit "x = -5.0 => x^2 = 25.0" *)
```

---

## Tests et conditions

### Tests avec `if`

syntaxe :

```ocaml
if <expression_booléenne> then
    <expression>
else if <expression_booléenne> then
    <expression>
...
else
    <expression>
```

toutes les expressions de sorties doivent renvoyer le même type.

un if qui renvoie `true` ou `false` est (en général) inutile.

exemples :

```ocaml
if estPair a then a + 1 else a

(* un bloc if-else *)
if x >= 5 then 
    moyenne x y
else
    moyenne 5 y
;;
```


### Les match-expressions (ou pattern matching)

syntaxe :

```ocaml
match <expression> with
| <val1> | <val2> | ... | <valn> -> <expression n°1>
...
| _                                 -> <dernière expression>
```

toutes les expressions de sorties doivent renvoyer le même type.

le cas `_` va "récupérer" tous les cas non traité opparavent.

exemple, on verifie que le jour donné est possible :

```ocaml
(* expression qui renvoit true si la date est valide et false dans le cas contraire *)
match m with
| 1 | 3 | 5 | 7 | 8 | 10 | 12 -> (1 <= jour) && (jour <= 31)
| 4 | 6 | 9 | 11              -> (1 <= jour) && (jour <= 30)
| 2                           -> (1 <= jour) && (jour <= 28)
| _                           -> Printf.printf "le mois %i n'existe pas\n%!" (m); false
;;

(* voir la section 2 de "compositions de fonctions" pour l'explication du ";" *)
```

on peut aussi "matcher" plusieurs variables en même temps.

```ocaml
(* expression qui compte le nombre de 42 dans le tuple (x, y): int*int *)
match x, y with
| (42, 42)          -> 2
| (_, 42) | (42, _) -> 1
| (_, _)            -> 0
;;
```

le pattern matching est une des notions fondamentales de la programation fonctionnelle, ce n'es que les bases. Il y aura plus tard une explication plus poussée pour expliquer les cas plus complexes.

---

## Composition de fonctions

### Les mot clé `in` et `and`

syntaxe: `let <var/func> = <expression> and <var/func> = <expression> and ... in <expression>`

permet de faire de la composition de fonction (comme f•g en maths). C'est LA notion fondamentale en programmation fonctionnelle.

exemples :

```ocaml
(* utiliser "in" pour définir des variables (x, a et b) *)
let x = carre y in estPair x
let a = x*2 and b = y*2 in moyenne a b

(* utilise  "in" pour définir une fonction (min2) et des variables (m et n) *)
let min4 (a: int) (b: int) (c: int) (d: int) : int =
    let min2 (x: int) (y: int) = 
        if x < y then x else y
    in
    let m = min2 a b and n = min2 c d in
    min2 m n
;;
```

### Le simple point-virgule 

le `;` permet d'enchainer des expressions sans rien passer à l'expression suivante, seule la dernière expression peut avoir un autre type que unit. Le type de sortie de l'enchainement d'expression est le type de sortie de la dernière expression.

exemples :

- afficher un message dans la console au mileu d'une expression :

```ocaml
(* écrit dans le terminal "le mois <n> n'existe pas" et renvoie "false" *)
Printf.printf "le mois %i n'existe pas\n%!" (n); false
```

- tester une fonction :

```ocaml
Printf.printf "le max de %i et %i est %i.\n%!" 12 27 (max2 12 27);
Printf.printf "le max de %i et %i est %i.\n%!" 32 27 (max2 32 27)
```

---

## Types customs et structures de donnés avancés

### Les types synonymes

Définir un type comme un alias d'un autre peut parraître inutile, mais cela permet d'écrire du code plus propre et simple à relire.

syntaxe : `type <nom_du_type> = <type>`

exemple :

```ocaml
type vitesse = float
type couleur = string
;;
```

### Les tuples (ou types produits)

On peut définir ce qu'on appelle un `tuple`, ce qui est une sorte de liste python mais qu'on ne peut pas modifier.

syntaxe : `let <nom_du_tuple> = (<var1>, <var2, ... <varn>: <type1> * <type2> * ... * <typen>)`

les tuples sont utiles pour stoquer un groupe de données, mais permettent surtout de renvoyer plusieures variables en même temps avec une seule fonction.

il est possible (et conseillé) de séparer la définition des type d'un tuple de la définition de ses éléments.

exemple de types customs et tuples dans un petit programme :

```ocaml
type position = int*int
type vecteur = int*int

(* Déplace un objet le long d'un vecteur donné *)
let deplace ((x, y): position) ((i, j): vecteur): position = ((x + i), (y + j))
;;
```

Remarques :

- On peut aussi écrire un tuple sous la forme `<var>` plutot que `(<elem_1>, ... , <elem_n>)` quand on veut juste transmettre le tuple sans y apporter de changements.
- Il est impossible d'afficher directement le contenu d'un tuple dans un print, il faut soit même créer une fonction qui permet de caster son tuple dans une chaine de caractère. Exemple :

```ocaml
let string_of_position ((x, y): position): string =
    "(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ")"

(* string_of_position (12, 5) => "(12, 5)" *)
```

### Les énumérés (ou types sommes)

Les variables de type dit "énumérés" sont des variables dont la valeur ne peut valloir que certaines valeurs décrites par des constructeurs.

syntaxe : `type <nom_du_type> = <constructeur1> | <constructeur2> | ... | <constructeurn>`

remarque : les constructeurs doivent **impérativement** commencer par une lettre majuscule.

exemples :

```ocaml
type etat_machine = On | Off | Standby
;;
```

Comme pour les tuples, il est impossible d'afficher directement un constructeur dans le terminal avec un print, il faut passer par une fonction intermédiaire. En règle générale, les match-expressions sont très efficaces pour traiter les énums, exemple :

```ocaml
type langages =
    | Python | C | Cpp | Bash | Java | Perl
    | JavaScript | Haskel | Ocaml | Elm | Fsharp

let tier_list_langages (l: langages): tiers = match l with
    | Bash | Elm          -> "S"
    | Python | JavaScript -> "A"
    | C | Haskel | Fsharp -> "B"
    | Cpp | Java          -> "C"
    | Perl                -> "F"
    | Ocaml               -> "Ocaml"
;;
```

On remarque qu'on a pas besoin du `_` car la match-expression est exaustive (on a traité toutes les valeurs possibles de l'énum "langages")

### Associer une valeur a un constructeur

On peut aussi associer une valeur a un constructeur pour créer des types de façon dynamiques, ce qui permet d'avoir un type qui contient une valeur de plusieurs types différents, ou un type qui contient des valeurs ou des constructeurs (en général on utilise le deuxième car le premier est très lourd et on peut le faire de façon beaucoup plus propre. Voir inférence de types).

syntaxe : `type <nom_du_type> = <constructeur_1> of <type_1> | ... | <constructeur_n> of <type_n>`

On peut "déconstruire" ces types avec des match-expressions, ce qui permet de récupérer la valeur d'un constructeur dynamique.

exemple :

```ocaml
(* Position d'une pièce sur un jeu d'échec. None si elle sort du terrain *)
type position = HorsPlateau | Coord of (int*int)

(* Avance un pion d'une case si il le peut, renvoie None sinon *)
let avance_pion ((x, y): int*int): position =
    if y >= 8 then HorsPlateau else Coord(x, y + 1)

(* Caste un type int*int en type string *)
let string_of_coord ((x, y): int*int): string =
    "(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ")"

(* Caste un type position en type string *)
let string_of_position (coord: position): string = match coord with
    | HorsPlateau -> "en dehors du plateau"
    | Coord(c)    -> string_of_coord c
;;

Printf.printf "La position du pion est %s.\n%!" (string_of_position(avance_pion(4, 5)));
(* Écrit dans la console : "La position du pion est (4, 6)." *)

Printf.printf "La position du pion est %s.\n%!" (string_of_position(avance_pion(4, 9)))
(* Écrit dans la console : "La position du pion est en dehors du plateau." *)
```

### Les types options

Les types options sont des types de donnés assez particuliers car ils permettent de renvoyer soit une valeur (d'un type donné), soit rien du tout. L'expression associée à la fonction doit pouvoir renvoyer au moins deux valeurs (à l'aide d'un `if` par exemple), `None` et `Some <var>` respectivement. On peut bien sûr avoir plusieurs `None` ou `Some <var>` dans la fonction. La différence avec un énum dynamique est qu'on a pas un type avec un ou plusieures constructeurs, on a un type synonyme classique mais la fonction précédente peut n'avoir rien renvoyé. Un enum a toujours une valeur.

syntaxe : `let <fonction> <args> = <expression>`

Pour utiliser les valeurs généré par une fonction utilisant un type option il faudra d'abord passer par une fonction intermédiaire pour traiter séparément le cas `None` du cas `Some <var>`. La valeur passé à cette fonction intermédiaire doit être de type `<type> option`.

exemple : On a un a un damier et on cherche la case au milieu de deux autres cases allignés.

```ocaml
let case = int * int

let milieu_cases ((i, j): case) ((x, y): case) =
    let milieu_existe ((i, j): case) ((x, y): case): bool =
        ((x-i) mod 2 = 0) && ((y-j) mod 2 = 0)
    in
    else if not (milieu_existe(i, j) (x, y)) then None
    else Some ((i + x) / 2, (j + y) / 2)

let str_of_case ((i, j): case): string =
    "(" ^ (string_of_int i) ^ ", " ^ (string_of_int j) ^ ")"

let str_of_case_option (c: case option): string =
    match c with
    | None   -> "None"
    | Some c -> str_of_case c
;;
```

### Les inférences de types (ou polymorphie)

Quand une fonction ou un constructeur d'un énum peut utiliser plusieurs types différents, on peut utiliser ce qu'on appelle de l'inférence de type. Concrètement, on défini un type générique dans la définition d'une fonction ou d'un autre type et le programme va récupérer le type des valeurs passé en arguments et associer ça au type générique. Il faut écrire le nom de ce type générique de la façon suivante : `'<nom_du_type_générique>`

Syntaxe (passer un type générique en argument à un énum) : `type '<arg> <enum> = <constructeur> of '<arg>`

Exemple, faire un arbre de décision à l'aide d'un énum d'énum :

```ocaml
(* Programme qui permet de se connecter à un réseau wifi *)
type ('a, 'b) resultat =
    | Succes of 'a
    | Echec of 'b

type reussite = string

type erreur =
    | WifiInconnu
    | PermissionRefuse
    | MauvaiseSecurite

let connection_wifi (reseau: string): string =
    let recuperer_message: (reussite, erreur) resultat = <inserer fonction> in
    match recuperer_message with
    | Succes(msg) -> msg
    | Echec(err)  -> match err with
        | WifiInconnu -> "resau wifi " ^ reseau ^ " inconnu"
        | PermissionRefuse -> "Connection au reseau " ^ resau ^ " refusé."
        | MauvaiseSecurite -> "Reseau wifi " ^ resau ^ " non sécurisé, abandon."
```

### Les types récursifs

On peut définir un énum de façon récursive, c'est à dire qu'il se contient lui même dans sa définition. Cet énum doit contenir au moins un constructeur statique pour que la récursion puisse s'arrêter. Cela permet de créer des arbres, car chaque élément contient une ou plusieures valeurs et un ou plusieurs autres énum qui contienent eux mêmes une ou plusieurs valeurs et au encore un ou plusieurs autres énums... jusqu'a ce qu'on atteigne la fin.

Syntaxe : `type <nom_du_type> = <constructeur_statique> | <constructeur_dynamique> of <type> * <nom_du_type>`

On peut avoir plusieurs constructeurs statiques ou constructeur dynamiques ayant une des tuples différents suivants le type d'arbre qu'on veut construire. Par exemple, avec un constructeur dynamique `<constructeur_dynamique> of (int*int) * <nom_du_type> * <nom_du_type>`, on va créer un arbre dont chaque branche contient un tuple `int*int` et deux autres branches.

Remarque : Si vous voulez utiliser un arbre dont toutes les valeurs ont le même type, une seule nouvelle branche au bout de chaque branche et un seul constructeur statique, vous venez de faire une liste. Faite pas ça, il existe déjà des listes en OCaml qui font la même chose que ça de façon beaucoup plus claire.

Exemple :

```ocaml
type ex_arbre = Feuilles | BrancheCoupe | Pos of (int*int*int) * ex_arbre * ex_arbre

(* un arbre possible avec le type ex_arbre est : *)
let arbre: ex_arbre =
    Pos((0, 0, 0),
        Pos((1, 0, 0),
            Pos((2, 1, -1), Feuilles, Feuilles),
            Pos((2, 1, 0), Feuilles, Feuilles)
        ),
        Pos((0, 1, 0),
            Pos((1, 3, 2), Feuilles, Feuilles),
            BrancheCoupe
        )
    )
```

On se retrouve donc avec un énorme tuple imbriqué de type ex_arbre. (Fonction pour dépiler tout ce bordel arrive bientôt)

---

## Fonctions récursives

Une fonction récursive est une fonction qui s'appelle elle même. La notion est très simple en théorie mais prend du temps à comprendre et à réussir à mettre en œuvre.

syntaxe : `let rec <fonction> = <expression>`

Remarques:

- Il faut que l'expression appelle à un moment la fonction qu'on définie.
- Une fonction récursive doit toujours au moins une façon de s'arrêter.

exemples :

```ocaml
(* Calcule le produit factoriel d'un nombre *)
let rec fact (n: int): int =
    match n > 1 with
    | true  -> n * fact(n - 1)
    | false -> n (* quand n = 1, on arrête la récursion, donc la fonction s'arrête. *)
;;

(*
Décomposition du fonctionnement de la fonction avec `fact 5`:
fact 5 = 5 * fact 4
    -> fact 4 = 4 * fact 3
        -> fact 3 = 3 * fact 2
            -> fact 2 = 2 * fact 1
                -> fact 1 = 1
                => fact 1 = 1
            => fact 2 = 2 * 1 = 2
        => fact 3 = 3 * 2 = 6
    => fact 4 = 4 * 6 = 24
=> fact 5 = 5 * 24 = 120
*)
```
