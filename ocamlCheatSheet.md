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
    * [Le type option](#le-type-option)
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

pour les listes :

- `::` : rajouter un élément au début d'une liste
- `@` : concaténer deux listes

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

Remarque: une variable est une fonction sans argument qui renvoie une constante, c'est pour ça qu'on ne peut pas modifier la valeur d'une variable en OCaml.

### Déclarer une fonction

Syntaxe: `let <nom_de_la_fonction> <arguments> : <type_de_sortie> = <expression>`

Pour chaque argument, on fait `(<nom_argument>: <type_argument>)`

Le type de sortie est le type de la valeur renvoyée.

Exemple :

```ocaml
let carre (x: float): float = x *. x
let estPair (x: int): bool = (x mod 2 = 0) (*mod : reste de la division euclidienne de deux entiers*)
let moyenne (x: float) (y: float): float = (x +. y) /. 2.0
let mesage: unit = Printf.printf "Hello world!!\n"
;;
```

Remarque : l'indentation et le retour à la ligne ne sont *techniquement* pas obligatoires mais sont très fortement conseillés pour rendre le programme plus lisible. On peut tout de même s'en passer quand la fonction est très simple (pas plus longue qu'une petite expression).

### Appeler une fonction

Syntaxe : `<nom_de_la_fonction> <argument1> <argument2> ... <argumentn>`

Appeler une fonction revient à utiliser une fonction prédéfinie, avec des variables donnés en entrée.

Exemples :

```ocaml
carre 5.0           (* renvoie 25 *)
moyenne 12.5 16.5   (* renvoie 14.5 *)
message             (* renvoie rien, affiche "un message très utile" dans la console *)
```

### Le double point-virgule (`;;`)

Le `;;` doit être utilisé après la dernière affectation. Il n'y a pas besoin de le mettre après chaque fin de ligne.

Exemple :

```ocaml
(* Version moche *)
let x : float = 12.0;;
let y = carre x;;
let z = estPair y;;
Printf.printf "Fin des affectations.\n";;

(* Version propre *)
let x : float = 12.0
let y = carre x
let z = estPair y
;;
Printf.printf "Fin des affectations.\n"
```

### Le rôle des parenthèses dans les appels de fonctions

On utilise les parenthèses pour rendre explicite les cas où les variables ou fonctions passé en argument a une autre fonction sont ambiguës. exemple :

```ocaml
moyenne carre -12.0 carre 17.0
(*
- -12.0 est vu comme un calcul et non un nombre négatif
- carre, -12.0, carre et 17.0 sont tous passé comme argument à moyenne, qui n'en demande que 2
- puisque -12.0 et 17.0 sont passé à moyenne, les deux `carre` n'ont pas d'arguments.
*)
moyenne (carre (-12.0)) (carre 17.0) (* ici, les arguments sont valides *)
```

Remarques :
- les parenthèses dans `moyenne (4.0) (5.0)` sont redondantes car l'expression n'est pas ambiguë.
- `moyenne (4.0 5.0)` va renvoyer une erreur car `4.0` et `5.0` sont vu comme un seul argument (voir tuples)


### Sémantique de fonctions

Les sémantiques sont les énormes commentaires qui expliquent comment une fonction fonctionne. Dans la vrai vie on fait pas ça mais puisque c'est demandé dans les compte-rendus on explique comment ça marche ici. La spécification explique ce que fait la fonction d'un point de vue très général, tandis que la réalisation s'attarde sur le détail du fonctionnement de la fonction.

Syntaxe :

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

Exemple :

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

Syntaxe: `Printf.printf "message" <val1> ... <valn>`

Caractères utiles :

- `\n` revient à la ligne, souvent utilisé en fin de message.

Pour insérer une variable dans le message, on écrit `%<première_lettre_du_type>`, si vous chercher à afficher le contenu d'un tuple ou d'un énum, allez voir la section "Caster des tuples et enmums" du chapitre "Types customs et structures de donnés avancés". Les variables vont être inséré dans l'ordre dont elles sont entré entre les parenthèses.

`Printf.printf` est de type unit.

Exemples :

```ocaml
Printf.printf "Hello World!\n"
Printf.printf "x = %f et b = %b\n" x b (* écrit dans le terminal "x = 42.12 et b = false" *)
Printf.printf "x = %f => x^2 = %f\n" x (carre x) (* écrit "x = -5.0 => x^2 = 25.0" *)
```

---

## Tests et conditions

### Tests avec `if`

Syntaxe :

```ocaml
if <expression_booléenne> then
    <expression>
else if <expression_booléenne> then
    <expression>
...
else
    <expression>
```

Toutes les expressions de sorties doivent renvoyer le même type.

Un if qui renvoie `true` ou `false` est (en général) inutile.

Exemples :

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

Syntaxe :

```ocaml
match <expression> with
| <val1> | <val2> | ... | <valn> -> <expression n°1>
...
| _                                 -> <dernière expression>
```

Toutes les expressions de sorties doivent renvoyer le même type.

Le cas `_` va "récupérer" tous les cas non traité opparavent.

Exemple, on verifie que le jour donné est possible :

```ocaml
(* expression qui renvoit true si la date est valide et false dans le cas contraire *)
match m with
| 1 | 3 | 5 | 7 | 8 | 10 | 12 -> (1 <= jour) && (jour <= 31)
| 4 | 6 | 9 | 11              -> (1 <= jour) && (jour <= 30)
| 2                           -> (1 <= jour) && (jour <= 28)
| _                           -> false
;;

(* voir la section 2 de "compositions de fonctions" pour l'explication du ";" *)
```

On peut aussi "matcher" plusieurs variables en même temps.

```ocaml
(* expression qui compte le nombre de 42 dans le tuple (x, y): int*int *)
match x, y with
| (42, 42)          -> 2
| (_, 42) | (42, _) -> 1
| (_, _)            -> 0
;;
```

Le mot-clé `when` peut aussi être utilisé pour apporter une condition en plus sur le patterne, par exemple :

```ocaml
match n with
| 42            -> "n vaut 42"
| x when x < 42 -> "n est inférieur à 42"
| _             -> "n est supérieur à 42"
```

Le pattern matching est une des notions fondamentales de la programation fonctionnelle, ce n'est que les bases. Il y a beaucoup d'autres façon plus poussé de reconnaîtres des patternes mais ils ne seront pas traité dans ici

---

## Composition de fonctions

### Les mot clé `in` et `and`

Syntaxe: `let <var/func> = <expression> and <var/func> = <expression> and ... in <expression>`

Permet de faire de la composition de fonction (comme f•g en maths). C'est LA notion fondamentale en programmation fonctionnelle.

Exemples :

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

Le `;` permet d'enchainer des expressions sans rien passer à l'expression suivante, seule la dernière expression peut avoir un autre type que unit. Le type de sortie de l'enchainement d'expression est le type de sortie de la dernière expression.

Exemples :

- afficher un message dans la console au mileu d'une expression :

```ocaml
(* écrit dans le terminal "le mois <n> n'existe pas" et renvoie "false" *)
Printf.printf "le mois %i n'existe pas\n" (n); false
```

- tester une fonction :

```ocaml
Printf.printf "le max de %i et %i est %i.\n" 12 27 (max2 12 27);
Printf.printf "le max de %i et %i est %i.\n" 32 27 (max2 32 27)
```

---

## Types customs et structures de donnés avancés

### Les types synonymes

Définir un type comme un alias d'un autre peut parraître inutile, mais cela permet d'écrire du code plus propre et simple à relire.

Syntaxe : `type <nom_du_type> = <type>`

Exemple :

```ocaml
type vitesse = float
type couleur = string
;;
```

### Les tuples (ou types produits)

On peut définir ce qu'on appelle un `tuple`, ce qui est une sorte de liste python mais qu'on ne peut pas modifier.

Syntaxe : `let <nom_du_tuple> = (<var1>, <var2, ... <varn>: <type1> * <type2> * ... * <typen>)`

Les tuples sont utiles pour stoquer un groupe de données, mais permettent surtout de renvoyer plusieures variables en même temps avec une seule fonction.

Il est possible (et conseillé) de séparer la définition des type d'un tuple de la définition de ses éléments.

Exemple de types customs et tuples dans un petit programme :

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

Syntaxe : `type <nom_du_type> = <constructeur1> | <constructeur2> | ... | <constructeurn>`

Remarque : les constructeurs doivent **impérativement** commencer par une lettre majuscule. Attention à ne pas utiliser le même nom de constructeur dans plusieurs types différents pour éviter de rendre le programme ambiguë. Cela inclu les constructeurs `None` et `Some of <type>` (voir type option).

Exemples :

```ocaml
type etat_machine = On | Off | Standby
;;
```

Comme pour les tuples, il est impossible d'afficher directement un constructeur dans le terminal avec un print, il faut passer par une fonction intermédiaire. En règle générale, les `match-expressions` sont très efficaces pour traiter les énums, exemple :

```ocaml
type langages =
    | Python | C | Cpp | Bash | Java  | JavaScript (* Quelques langages (orienté) objet *)
    | JavaScript | Haskel | Ocaml | Elm | Fsharp (* Quelques langages fonctionnels *)
	| Rust | Perl (* les langages vraiment chelou *)

let tier_list_langages (l: langages): tiers = match l with
    | Bash | Elm | Rust   -> "S"
    | Python | JavaScript -> "A"
    | C | Haskel | Fsharp -> "B"
    | Cpp | Java          -> "C"
    | Perl                -> "F"
    | Ocaml               -> "Ocaml"
;;
```

On remarque qu'on a pas besoin du `_` car la `match-expression` est exaustive (on a traité toutes les valeurs possibles de l'énum "langages")

### Associer une valeur a un constructeur

On peut aussi associer une valeur a un constructeur en lui passant un argument, ce qui permet d'avoir les constructeurs qui sont très efficaces dans les matche-expressions et imparable niveau lisibilité, mais aussi avoir la valeur dont on pourrait avoir besoin dans un seul paqué bien joli.

Syntaxe : `type <nom_du_type> = <constructeur_1> of <type_1> | ... | <constructeur_n> of <type_n>`

On peut "déconstruire" ces types avec des `match-expressions`, ce qui permet de récupérer la valeur d'un constructeur avec un argument.

Exemple :

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

Printf.printf "La position du pion est %s.\n" (string_of_position(avance_pion(4, 5)));
(* Écrit dans la console : "La position du pion est (4, 6)." *)

Printf.printf "La position du pion est %s.\n" (string_of_position(avance_pion(4, 9)))
(* Écrit dans la console : "La position du pion est en dehors du plateau." *)
```

### Les fonctions / énums génériques

Quand une fonction ou un constructeur d'un énum peut utiliser plusieurs types différents, on peut définir un type générique qu'on va utiliser pendant la définition de la fonction / enum. L'interpretteur d'ocaml va donc déterminer à la volée quel type on a passé et l'utiliser à la place du type générique au long de la fonction / enum. Dans le cas des énums, il faut demander ces types génériques en argument, qui sont écrit *avant* le type principal. Il faut écrire le nom de ce type générique de la façon suivante : `'<nom_du_type_générique>`

Syntaxe (passer un type générique en argument à un énum) : `type '<arg> <enum> = <constructeur> of '<arg>`

Exemple, faire un arbre de décision à l'aide d'un énum d'énum :

```ocaml
(* Programme qui permet de se connecter à un réseau wifi *)
(* Type générique auquel on peut passer en argument les types
   qu'on va utiliser en cas de succés et d'échec *)
type ('a, 'b) resultat =
    | Succes of 'a
    | Echec of 'b

(* Si on a réussi à se connecter, on a juste à afficher un message *)
type reussite = string

(* En cas d'erreur, on veut savoir quelle erreur on a eu en particulier *)
type erreur =
    | WifiInconnu
    | PermissionRefuse
    | MauvaiseSecurite

(* On affiche le bon message à l'écran suivant l'état de la connexion *)
let afficher_etat_connexion (reseau: string): unit =
	(* Fonction un peu bullshit pour simuler un résultat de connexion *)
	let recuperer_message (reseau: string): (reussite, erreur) resultat =
		match reseau with
		| "wifi_telephone" -> Succes("Connexion établie")
		| "wifi_fbi"       -> Echec(PermissionRefuse)
		| "wifi_public"    -> Echec(MauvaiseSecurite)
		| _                -> Echec(WifiInconnu)
	(* On desside quel message afficher suivant le resultat *)
	in txt = match recuperer_message reseau with
    | Succes(msg) -> msg            (* si la connexion est établie *)
    | Echec(err)  -> match err with (* si il y a eu une erreur *)
        | WifiInconnu      -> "resau wifi " ^ reseau ^ " inconnu"
        | PermissionRefuse -> "connexion au reseau " ^ resau ^ " refusé."
        | MauvaiseSecurite -> "Reseau wifi " ^ resau ^ " non sécurisé, abandon."
	(* On affiche le message *)
	in Printf.printf "%s\n" txt
```

Remarque, les enums d'énums sont très efficaces pour faire des arbres de décision complexes, et que l'inférence de type nous permet de garder des types très flexibles.

### Le type option

Le type option est un type prédéfini en OCaml qui permet de renvoyer soit une valeur (d'un type donné), soit rien du tout. La fonction qui utilise ce type doit pouvoir renvoyer au moins deux valeurs (à l'aide d'un `if` par exemple), `None` et `Some <var>` respectivement. On peut bien sûr avoir plusieurs `None` ou `Some <var>` dans la fonction.

Concrêtement, un type option est énum défini de la façon suivante : `type 'a option = None | Some of 'a`. (n'écrivez pas ça dans votre code, ce type est prédéfini). Il s'utilise donc comme n'importe quel type demandant un argument.

On peut ensuite traiter les valeurs générés avec une simple `match-expression`.

Exemple : On a un a un damier et on cherche la case au milieu de deux autres cases allignés.

```ocaml
(* Décris la position d'une case *)
let case = int * int

(* Calcule le milieu de deux cases (si il existe) *)
let milieu_cases ((i, j): case) ((x, y): case): case option =
	(* On vérifie que le milieu des deux cases existe *)
    let milieu_existe ((i, j): case) ((x, y): case): bool =
        ((x-i) mod 2 = 0) && ((y-j) mod 2 = 0)
    in
    else if not (milieu_existe(i, j) (x, y)) then None (* si non, renvoie None *)
    else Some ((i + x) / 2, (j + y) / 2) (* si oui, renvoie le milieu *)

(* Converti une case en string *)
let str_of_case_option (c: case option): string =
	let str_of_case ((i, j): case): string =
		"(" ^ (string_of_int i) ^ ", " ^ (string_of_int j) ^ ")"
	in match c with
    | None   -> "None"
    | Some c -> str_of_case c
;;
```

### Les types récursifs

On peut définir un énum de façon récursive, c'est à dire qu'il se contient lui même dans sa définition. Cet énum doit contenir au moins un constructeur qui ne fait pas la récursion pour que la récursion puisse s'arrêter. Cela permet de créer des arbres, car chaque élément contient une ou plusieures valeurs et un ou plusieurs autres énum qui contienent eux mêmes une ou plusieurs valeurs et au encore un ou plusieurs autres énums... jusqu'a ce qu'on atteigne la fin.

Syntaxe : `type <nom_du_type> = <constructeur> | <constructeur> of <type> * <nom_du_type>`

exemple :

```ocaml
type 'a liste_debile = 
	| Fin
	| Elem of 'a * liste_debile

let liste: int liste_debile = Elem(12, Elem(-5 , Elem(69420, Fin)))
;;
```

Cette façon de faire des liste est vraiment lourde et il existe des vrais liste, donc il vaut mieux utiliser ça quand c'est possible. par contre, contrairement au listes les types récursifs permettent d'avoir plusieurs constructeurs qui font la récursion pour (par exemple) avoir une liste de plusieurs types différents. On peut aussi avoir un contructeur qui fait plusieurs fois la récursion et donc faire un arbre.

Exemple :

```ocaml
type arbre =
	| Feuilles
	| BrancheCoupe
	| Pos of (int*int*int) * arbre * arbre

(* un arbre possible avec le type ex_arbre est : *)
let petit_arbre: arbre =
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
;;
```

On se retrouve donc avec un énorme tuple imbriqué de type arbre. Pour voir comment utiliser ces arbres dans une fonction, allez voir la section sur le traitement des types récursifs dans le chapitre sur les fonctions récursives.

## Les listes

Les listes permettent de faire une séquence d'éléments d'un type donnés. On définit une liste avec la syntaxe suivante : `<nom_liste>: <type> list = [<elem1>; <elem2>; ... ; <elem_n>]`

par exemple :

```ocaml
type nom = str
type age = int
type humain = nom * age

let copains: humains list = [("Jaquie", 52); ("Michelle", 69)]
;;
```

On retrouve deux opérateurs pour travailler sur les liste : `::` et `@`. Le premier permet de rajouter un élément au début d'une liste, donc par exemple :

```ocaml
[12; 42] = 12 :: [42] = 12 :: 42 :: []
```

Le `@` quand à lui permet de concaténer (metre bout à bout deux listes), donc par exemple :

```ocaml
[1; 2; 3] @ [4; 5; 6] = [1; 2; 3; 4; 5; 6]
```

Non on ne peut pas chercher un élément en particulier d'une liste (en tout cas pas sans le module `List`), contrairement à tous les autres langages de prog du monde, parce que fuck ocaml

---

## Fonctions récursives

### Les bases des fonctions récursives

Une fonction récursive est une fonction qui s'appelle elle même. La notion est très simple en théorie mais prend du temps à comprendre et à réussir à mettre en œuvre.

Syntaxe : `let rec <fonction> = <expression>`

Remarques:

- Il faut que l'expression appelle à un moment la fonction qu'on définie.
- Une fonction récursive doit toujours au moins une façon de s'arrêter.

Exemples :

```ocaml
(* Calcule le produit factoriel d'un nombre *)
let rec fac (n: int): int =
	match n with
	| 0 | 1        -> 1 (* On ne rappelle pas la fonction donc la récurence s'arrête *)
	| x when x < 0 -> fac (-x)
	| _            -> n * fac (n-1)
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

### Traiter un type récursif

On va utiliser des fonctions récursives pour traiter les types récursifs, car ils contiennent "un élément puis la suite", par exemple si on veut récupérer le nombre d'éléments d'une 'liste' créé avec un type récursif on peut faire ça:

```ocaml
type 'a liste_debile = 
	| Fin
	| Elem of 'a * ('a liste_debile)

let liste: int liste_debile = Elem(12, Elem(-5 , Elem(69420, Fin)))

let rec  longueur (l: 'a liste_debile): int =
	match l with
	| Fin -> 0
	| Elem(_, suite) -> 1 + longueur suite
;;
```

Un arbre est juste un type récursif avec plusieures branches, donc il suffit de faire la récursion sur chacune de ces branches, par exemple, on va reprendre l'arbre défini dans la section sur les types récursifs et afficher son contenu avec des jolis indentations :

```ocaml
(* Défini un arbre dont chaque noeud a une position et donne deux branches *)
type arbre =
	| Feuilles
	| BrancheCoupe
	| Pos of ((int*int*int) * arbre * arbre)

(* Décris le niveau de récurence à l'intérieur de affiche_arbre *)
type profondeur = int

(* un arbre possible avec le type arbre est : *)
let petit_arbre: arbre =
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

(* La fonction qui affiche l'arbre, toujours appeler avec n=0 *)
let rec affiche_arbre (a: arbre) (n: profondeur): unit =
	(* Fonction intermédiaire qui affiche un élément de l'arbre dans le term *)
    let affiche_noeud (txt: string) (n: profondeur): unit =
		(* Fonction intermédiaire qui permet de mettre la bonne indentation *)
        let rec text_indente (txt: string) (n: profondeur): string = 
            match n with
            | 0 -> " -> " ^ txt
            | _ -> "    " ^ text_indente txt (n-1)
        in Printf.printf "%s\n" (text_indente txt n)
        
	(* Convertir un tuple (x, y, z): int*int*int en string *)
    and string_of_tuple ((x, y, z): int*int*int): string =
        "(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ", " ^ string_of_int z ^ ")"
    in
	(* On regarde quel constructeur on a pour savoir quoi afficher dans le term *)
    match a with
    | Feuilles             -> affiche_noeud "feuilles" n
    | BrancheCoupe         -> affiche_noeud "branche coupé" n
    | Pos((x, y, z), b, c) -> affiche_noeud(string_of_tuple(x, y, z)) n; affiche_arbre b (n+1); affiche_arbre c (n+1)
	(* Les deuxième éléments de Pos contiennnent la suite de l'arbre,
	   donc on appelle la fonction sur eux *)

(* affiche_arbre petit_arbre 0 affiche :
 -> (0, 0, 0)
     -> (1, 0, 0)
         -> (2, 1, -1)
             -> feuilles
             -> feuilles
         -> (2, 1, 0)
             -> feuilles
             -> feuilles
     -> (0, 1, 0)
         -> (1, 3, 2)
             -> feuilles
             -> feuilles
         -> branche coupé

Oui c'est inutilement compliqué mais le résultat est très joli (: *)
```

Remarque : même si l'arbre de départ est plutot complexe, on peut remarquer que la fonction pour le parcourir reste (relativement) simple, car on ne match qu'un seul élément à la fois et qu'après le match, les traitements sont simples.

### Traiter une liste

Traiter une liste est très similaire à traiter un type récursif, on va faire une fonction récursive qui va demander une liste en argument, puis un va faire une match expression pour voir si la liste est vide (pour savoir quand arrêter la récursion), puis on va regarder le premier élément de la liste, le traiter, et recommencer avec la suite.

Exemple :

```ocaml
let l: int list = [2; 5; 8; 3; 2; 2; 4]

let rec nb_occurences (l: 'a list) (val_a_chercher: 'a) =
	match l with
	| [] -> 0
	| elem :: suite -> (
		if elem = val_a_chercher then
			1 + nb_occurences suite val_a_chercher
		else 
			nb_occurences suite val_a_chercher
	)
;;

Printf.printf "%d\n" (nb_occurences l 2);
(* Affiche 3 *)
```

---

## Les fonctions d'ordre supérieur

Les fonctions d'ordres supérieurs sont des fonctions qui demande en argument et / ou renvoient d'autre fonctions.

### Passer en argument / renvoyer une fonction

Vous avez surement remarqué que dans une console ocaml, les une fonction qui prends en argument un int en renvoie un int est écris de la façon suivante : `int -> int = <fun>`. On peut utiliser une notation très similaire pour décrire le type d'une fonction passé en argument ou renvoyé, par exemple, si on veut faire une fonction qui calcule une approximation de la dérivée d'une fonction en un point on peut faire ça :

```ocaml
let derivee_v1 (f: float -> float) (x: float): float =
	let dx = 0.0000001 in
	(f (x +. dx) -. f x) /. dx (* oubliez pas les `.` pour les opérateurs des floats *)
;;

Printf.printf "%f\n" (derivee_v1 sin 0.);
(* Affiche "1." *)
```

### Les fonctions anonymes

Les fonctions anonymes sont des fonctions qui n'ont pas de nom (comme leur nom l'indique). Elles sont utilisés pour générer à la volée des fonctions, ce qui permet notemment à une fonction de renvoyer une autre fonction.

syntaxe : `fun <args> -> <corps_de_la_fonction>`

Dans l'exemple précédent, on a fait une fonction qui calcule la dérivée d'une fonction en un point, mais on peut l'adapter un peut pour qu'elle renvoie à la place la dérivee de la fonction :

```ocaml
let derivee_v2 (f: float -> float): float -> float =
	let dx = 0.000001 in
	fun x -> (f (x +. dx) -. fx) /. dx
;;

Printf.printf "%d\n" ((derivee_v2 (fun x -> x**2. +. 3.*.x +. 12.)) 5.);
(* Affiche 13.00000188... *)
```

Dans cet exemple, on a généré une fonction à la volée avec `fun` et calculé sa dérivée. On note les parenthèses autour de la fonction `derive` et la fonction passé en argument, c'est pour éviter que `5.` soit passé comme un deuxième argument à derivee, mais plutôt comme un argument passé à la fonction qui sort de `derivee <fct>`.

### Curification

La curification (en plus d'avoir le meilleur nom de tous les temps) est vraiment utiles pour faire des raccourcis en ocaml. Le principe est que si on ne donne pas les n derniers arguments à une fonction, au lieu de renvoyer une valeur, la fonction va renvoyer une fonction anonyme qui va demander n arguments (qui auront les mêmes types que les arguments ignorés), et qui va agir comme la fonction d'origine une fois qu'on donne ces arguments manquants.

exemple, on calcule la dérivée d'une fonction avec `derivee_v1` :

```ocaml
let f_prime = (derivee_v1 (fun x -> x *. 3.))
;;

Printf.printf "%d\n" (f_prime 12.);
(* Affiche 2.9999999..... *)
```

Vu comme ça, la curification parraît pas super utile, mais on va voir que c'est particulièrement utile avec les fonctions du module `List`.

## Le module List

On a vu précédemment qu'une façon de traiter une liste est de passer par une fonction récursive, mais on peut gagner beaucoup de temps avec les fonctions du module `List`. Il existe beaucoup de fonctions dans ce module, mais on va voir les plus importantes. (toutes les fonctions du modules sont données ici : https://v2.ocaml.org/api/List.html)

### List.mem

`List.mem` prends en argument une valeur puis une liste et renvoie `true` si l'élément est présent dans la liste et `false` sinon.

exemple :

```ocaml
let l: int list = [1; 2; 3; 4; 5]
;;

Printf.printf "%b, %b\n" (List.mem 12 l) (List.mem 2 l);
(* Affiche "false, true" *)
```

### List.map

`List.map` va prendre en argument une fonction (qui ne demande qu'un seul argument) puis une liste, et va renvoyer une nouvelle liste composé des éléments de la liste précédentes après être passé dans la fonction.

exemple :

```ocaml
let l1: int list = [1; 2; 3; 4; 5]
let l2: int list = List.map (( + ) 2) l1
;;

(* l2 = [3; 4; 5; 6; 7] *)
```

Dans cet exemple, on peut remarqué qu'on a curifié l'opérateur `+` pour en faire une fonction qui demande deux arguments et les additionnent, sauf qu'on a direct donné 2, donc `List.map` a ajouté 2 à tous les éléments de la liste. Cela revient à faire `fun n -> n + 2`, mais en beaucoup plus court

### List.filter

`List.filter` va prendre en argument une fonction (qui demande un argument et qui renvoie un booléen) et une liste, et va renvoyer une liste de tous les éléments qui donnent `true` en passant dans la fonction.

exemple :

```ocaml
let l1: int list = [1; 2; 3; 4; 5]
let l2: int list = List.filter (fun n -> n <= 3) l1
;;

(* l2 = [1; 2; 3] *)
```

### List.filter_map

C'est une combinaison de `List.filter` et `List.map`, ça va prendre en argument une fonction (qui demande un argument et renvoie un type option) et une liste et renvoie une liste avec toutes les valeurs à l'intérieur des constructeurs `Some` et ignorer tous les `None`.

exemple :

```ocaml
let f (n: int): int option =
	if n * 2 >= 6 then
		Some(n * 2)
	else
		None

let l1: int list = [1; 2; 3; 4; 5]
let l2: int list = List.filter_map f l1
;;

(* l2 = [6; 8; 10] *)
```

### List.fold_left

`List.fold_left` permet de réduire une liste à un élément. Elle demande :

- une fonction qui va demander deux arguments (respectivement de type `'a` et `'b`) qui va renvoyer une valeur de type `'a` (voir les fonctions génériques)
- une valeur de départ de type `'a`
- une liste de type `'b'`

et va renvoyer à la fin une valeur de type `'a`

La fonction va d'abord prendre la valeur de départ et le premier élément de la liste et les passer en argument à la fonction, ce qui va renvoyer une valeur. La fonction va ensuite récupérer cette valeur, prendre le deuxième élément de la liste et les passer en argument à la fonction. Cela va répèter ce processus jusqu'à ce que la liste soit vide.

Remarque : `'a` et `'b` peuvent être le même type.

Exemple :

```ocaml
let l: int list = [37.; 4.; 52.]
;;

(* Affiche l'élément le plus petit de la liste *)
Pritnf.printf "%f\n" (List.fold_left min Float.infinity l);
(* Affiche "4." *)
```

### List.fold_right

`List.fold_right` est très similaire à list.fold_left sauf qu'au lieu de générer une valeur avec le premier élément de la liste et une valeur de départ, puis la passer en argument à la fonction avec le deuxième élément de la liste (et ainsi de suite), on va modifier la valeur de départ en passant en argument successivement toutes les valeurs de la liste.

par exemple :

```ocaml
type mouvement = Haut | Bas | Gauche | Droite
type position = int * int

let position_robot: position = (0, 0)

let deplacement (m: mouvement) ((x, y): position): position =
	match m with
	| Haut   -> (x, y+1)
	| Bas    -> (x, y-1)
	| Gauche -> (x-1, y)
	| Droite -> (x+1, y)

let liste_mouvement: mouvement list = [Haut; Droite; Droite; Bas; Droite]

let affiche_position ((x, y): position): unit =
	Printf.printf "(%d, %d)\n" x y
;;

affiche_position (List.fold_right deplacement liste_mouvement position_robot);
(* Affiche "(3, 0)" *)
```
