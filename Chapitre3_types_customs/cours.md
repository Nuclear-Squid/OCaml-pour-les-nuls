# Chapitre 3 : Types de données et modules

La programmation fonctionnelle à débuté en tant qu'un domène de recherche en
informatique, donc le fonctionnement d'une fonction peut souvent être démontré
mathématiquement. Les deux démonstrations les plus courantes sont : montrer qu'un
fonction a une image quelque soit les paramêtres en entrée (ces fonctions sont
dites `pure`), et montrer qu'une fonction récursive va forcément s'arrêter à un
moment (aussi appelé une `mesure`).

Même si ces démonstrations sont souvent évidentes, il est important de savoir les
faire, car elles permettent de pouvoir repérer des bugs plus tôt et garantir au
moment de compiler que rien d'affreux peut arriver (comme appeler une methode sur
un null dans un langage objet, par exemple).

Un des outils tangible que la recherche nous a apporté dans les langages fonctionnels
sont les `types de données algébriques`. Ce nom représente tout un système de types
qui permet d'effectuer des opérations sur ces types et même de créer nos propres types,
et c'est ce qu'on va voir au sein de ce chapitre.

# 1. Les tuples et types alias

On a vu dans le chapitre 2 qu'on peut regrouper des valeurs sous un tuple.
On va maintenant voir comment on décrit leur type :

```ocaml
(* syntaxe : <type_1> * <type_2> * … * <type_n> *)
let origine: int * int = (0, 0)
```

On sépare les types de données par des `*` car le type `int` peut être représenté
comme l'ensemble des intiers relatifs, donc le grand type `int * int` représente
l'ensemble des couples d'entiers possibles. En d'autres termes, un tuple de deux
entiers est le produit cartésiens de deux ensemble des nombres entiers relatifs.
(on peut donc utiliser les noms `tuple` ou `type produit` interchangeablement)

Tout compte fait, on a pas ajouté beaucoup d'informations, car on peut déjà voir
que la variable contient un couple d'entiers et on peut représenter beaucoup de
choses totalement différentes avec un couple d'entiers au sein d'un même programme,
comme la position d'une case sur un terrain (comme la variable `orgine`), un vecteur
ou un intervalle entre deux valeurs. Ce qu'on peut faire, c'est donner un nom à ces
type produit pour rendre explicit ce qu'ils représentent :

```ocaml
(* syntaxe : type <nom_type> = <type> *)

(* La position d'une case sur le terrain *)
type point = int * int

(* La translation d'une case à une autre, sur le terrain *)
type vecteur = int * int

(* Un intervalle {a, …, b}, tel que a <= b *)
type intervalle = int * int
```
On peut aussi en profiter décrire quelles restrictions on impose sur le type (comme
on a fait pour le type `intervalle`), OCaml ne pourra jamais les vérifier à notre
place, mais c'est déjà ça.

On peut maintenant utiliser ces nouveaux types de données dans nos signatures de
fonctions pour représenter sans ambiguités les données traitées :

```ocaml
(* C'est la seule variable de la forme (longueur, largeur) du programme,
   donc on a pas besoin d'en faire un type spécial, tant que le nom est explicit *)
let dimentions_terrain = (10, 10)

(* Quelques opérations simples sur les vecteurs *)
let translation_case (x1, y1: vecteur) (x2, y2: point): point = (x1 + x2, y1 + y2)
let vecteur_fois_int (x, y: vecteur) (n: int): vecteur = (x * n, y * n)

(* Vérifie qu'une valeur est compris dans un intervalle (bornes incluses *)
let compris_dans (a, b: intervalle) (n: int) = a <= n && n <= b

(* Vérifie qu'une case est dans les limites du plateau *)
let est_dans_plateau (x, y: point): bool =
	let dim_x = fst dimentions_terrain / 2  (* on lit une constante globale. *)
    and dim_y = snd dimentions_terrain / 2  (* `fst` renvoie le premier élément d'un *)
	in                                      (* couple, et `snd` le second *)
	compris_dans (-dim_x, dim_x) x && compris_dans (-dim_y, dim_y) y
```

Comme on peut le voir, on a beau avoir 4 types d'informations différentes représenté
par un couple d'entier, le programme reste clair, car on peut mettre un nom sur
les différents types.

On appelle ces types qui ne sont juste un autre nom sur un type existant des `types
alias`, et on peut les utiliser interchangeablements. Par exemple, si on a une
variable de type `point`, mais qu'on veut la considérer comme le vecteur entre
l'origine et ce point, on peut la passer direct dans une fonction qui demande un
vecteur, puisque dans tous les cas on a passé un couple d'entier (attention à
bien vérifier les contraintes sur les types ou les convertions qui vont bien avant
de faire ça, par contre).

# 2. Les structs

Pour les élèves de la fac qui suivent ce cours, vous n'aurez probablement pas
besoin de savoir comment les `records` (le nom qu'OCaml donne à ce qu'on appelle
dans n'importe quel autre langage un `struct`) fonctionne, mais je trouve que
c'est une notion simple qui est très utile.

## 2.1. Les bases

Un `struct` (ou record), est un type de donnée qui définie une structure qui
contient un nombre fini de valeurs, toutent ayant un nom et un type prédéfini
(on appelle ces valeurs les `champs` du struct). C'est un peu comme un tuple
avec des valeurs nommés.

Par exemple, on va définir un struct qui va représenter un petit robot qui se
déplace sur le terrain. Pour l'instant on va juste avoir besoin de son nom et
de sa position :

```ocaml
(* syntaxe :
type <nom_type> = {
	<nom_champ_1>: <type_champ_1>;
	...
	<nom_champ_n>: <type_champ_n>;
} *)

type robot = {
	nom: string;
	position: point;
}
```

On peut après déclarer une instance de ce struct et lire le contenu d'un champ
de la façon suivante :

```ocaml
let () =
	(* on peut affecter les champs dans l'ordre qu'on veut *)
	let curiosity: robot = {
		position = (0, 0);
		nom = "Curiosity";
	}
	in
	printf "%s\n" curiosity.nom
```

## 2.2. Décompositions de struct

Il est possible de décomposer un struct, comme n'importe quelle valeur en OCaml,
mais certains raccourcis peuvent être utilisé. Par exemple, écrivons une fonction
qui affiche le nom du robot passé en argument. Une façon de l'implémenter est :

```ocaml
let affiche_nom_robot (r: robot) = printf "%s\n" r.nom
```

Mais on peut peut décomposer le type `robot` pour ne récupérer que son nom :

```ocaml
(* syntaxe : { <nom_champ> = <pattern>; ... } = <struct> *)
(* Ici, le `_` va ignorer tous les autres champs non précisé du struct *)
let affiche_nom_robot (r: robot) =
	let { nom = nom_robot; _ } in
	printf "%s\n" nom_robot
```

Si on ne donne pas de valeur au champ du struct quand on le décompose, on va définir
une variable qui a le même nom que le champ du struct qu'on cherche à décomposer.
C'est ce qu'on appelle du `field punning`

```ocaml
let affiche_nom_robot (r: robot) =
	let { nom; _ } = r in
	printf "%s\n" nom
```

Ici, on a décomposé le struct dans un bloc `let … in`, mais on peut aussi le faire
directement dans l'arguement de la fonction :

```ocaml
(* Décomposer un struct en inférant son type peut être ambigue quand plusieurs
   structs partagent un même nom de champ *)
let affiche_nom_robot { nom; _ } = printf "%s\n" nom
```

## 2.3. Updates foncionnels

Imaginons maintenant qu'on veut faire une fonction qui reset la position du robot,
c'est-à-dire le placer en position `(0, 0)`. On peut écrire cette fonction de façon
naïve :

```ocaml
let reset_position (r: robot) = {
	position = (0, 0);
	nom = r.nom;
}
```

Le problème est qu'il faudra recopier à la main tous les champs qui ne changent pas,
ce qui peut vite devenir inutilement verbeux. Heureusement, on peut utiliser le mot
clé `with` pour ne redéfinir que les valeurs des champs qui changent :

```ocaml
(* syntaxe :
{ <struct_origine> with 
	<champ_1> = <valeur_1>;
	...
	<champ_n> = <valeur_n>
} *)
let reset_position (r: robot) = { r with position = (0, 0) }
```

On appelle ça un `update fonctionnel` car ça ne va pas modifier le struct, mais
en renvoyer un nouveau qui va avoir les même valeurs que le struct d'origine à
l'exception des champs présicés qui vont avoir leur nouvelle valeur.

# 3. Les enums

## 3.1. Les bases

Il nous reste encore un champ à rajouter au struct `robot`, son orientation. On
pourrait utiliser un entier (0 = nord, 1 = est...) ou une chaîne de caractères pour
représenter cette valeur, sauf que non seulement les entier ne sont pas explicit,
mais dans les deux cas on retombe dans le même problème, on utilise juste 4 valeurs
arbitraires parmis une infinité de valeurs possible, ce qui est prône à l'erreur
et nous force à utiliser une wildcard inutile dans les matchs expression, même quand
on est sûr de ce qu'on fait (ce qui n'es généralement pas le cas…).

Ce qu'on peut faire, c'est définir un `enum` (aussi appelé `type somme`), un type
de données qui contient un nombre fini de valeurs possibles qui ont un nom explicit.
On appelle les différentes valeurs d'un enum des `variantes`, et leur nom doit
*impérativement* commencer par une lettre en majuscule.

```ocaml
(* syntaxe : type <nom_du_type> = <Variante_1> | <Variante_2> | … | <Variante_n> *)
type point_cardinal = Nord | Sud | Est | Ouest

(* Le nouveau type robot : *)
type robot = {
	nom: string;
	position: point;
	orientation: point_cardinal;
}
```

On peut ensuite utiliser ce type dans des match-expressions, et vu qu'on a un
nombre fini de valeurs, OCaml peut vérifier au moment de compiler qu'on est bien
exhaustif (et va refuser de compiler si ce n'es pas le cas) :

```ocaml
let tourner_gauche (r: robot): robot =
    let nouvelle_orientation =
        match r.orientation with
        | Nord  -> Ouest
        | Ouest -> Sud
        | Sud   -> Est
        | Est   -> Nord
    in { r with orientation = nouvelle_orientation }
```

## 3.2. Les variantes avec arguments

Une variante d'enum peut aussi encapsuler une valeur, qu'on va appeler un `argument`.
Ça peut être pratique quand une ou plusieurs variantes ont besoin de données en
plus pour représenter une action ou valeur.

Par exemple, imaginons que les robots qu'on pilote doivent pouvoir tourner à
gauche, à droite et avacer sur plusieures cases. On peut décrire ces actions avec
un enum, et donner un entier en argument à la variante `Avancer` pour dire de
combien de cases on doit avancer (ou reculer si l'argument est négatif) :

```ocaml
(* syntaxe : | <NomVariante> of <type> *)
type actions =
	| Gauche
	| Droite
	| Avancer of int
(* On peut écrire les enums sur plusieures lignes, ce qui est recommandé quand
   le type commence à être complexe *)
```

Remarque : une variante ne peut avoir qu'un seul argument, donc si on veut encapsuler
plusieurs valeurs, il faudra demander un tuple en argument.

On peut ensuite décomposer cet enum avec une match expression, par contre quand
on va décomposer la variante `Avancer`, il faudra préciser un pattern qui porte
sur son argument :

```ocaml
(* Applique l'action demandé sur le robot *)
(* Les fonctions aller_tout_droit et tourner_droite sont dans main.ml *)
let effectue_action (action: actions) (r: robot) =
    match action with
    | Avancer n_cases -> aller_tout_droit n_cases r
    | Gauche -> tourner_gauche r
    | Droite -> tourner_droite r
```

## 3.3. Les structs encapsulés

Parfois, l'argument d'une variante est vraiment compliqué et on voudrais en faire
un struct, sauf qu'on a uniquement besoin de ce struct pour cette variante en
particulier. Ce qu'on peut faire, c'est déclarer la signature d'un struct dans
le type d'argument de la variante :

```ocaml
type connection_status =
	| Connected of {
		host: string;
		port: int;
	}
	| InProgress of {
		time: int
	}
	| Failed of {
		reason: string;
	}
```

Ça permet d'être plus explicit sur les arguments des variantes sans pourrir son
name-space global, mais le gros inconvenient de cette methode c'est qu'on ne pourra
jamais extraire le struct de cette variante d'enum :

```ocaml
let extraire_info (status: connection_status) =
	match status with
	| Connected info -> Some info  (* Impossible *)
	| _ -> None
```
	
# 4. Les types génériques

## 4.1 Les bases

Généralement, une fonction demande un type de donnée précis en entrée, et renvoie
un type précis en sortie. Cependant, il arrive parfois d'écrire une fonction qui
pourrait marcher sur n'importe quel type (parce qu'on ignore la valeur des arguments
ou que l'expression est extremmement simple…). Par exemple, on va
réimplémenter les fonctions `fst` et `snd` du module `Base`, qui renvoie respectivement
la première et la deuxième valeur d'un tuple de deux éléments :

```ocaml
let fst ( x, _y) = x
let snd (_x,  y) = y
```

Comme on peut le voir, la fonction est tellement simple qu'elle peut fonctionner
avec n'importe quel tuple de deux éléments. On peut quand même rendre les types
des arguments explicites en donnant aux arguments un type arbitraire préfixé par
un appostrophe. Par exemple, si on utilise dans la signature de fonction les types
`'a` et `'b`, on va dire ces types peuvent être n'importe quoi, par contre il faut
que tous les arguments / valeurs de retour utilisant un même nom de type arbitraire
utilise le même type au moment d'appeler la fonction :

```ocaml
(* Les types 'a et 'b sont indépendants, aucunes restrictions entre eux *)
let fst ( x, _y: 'a * 'b): 'a = x  (* La sortie doit être du même type que x *)
let snd (_x,  y: 'a * 'b): 'b = y  (* La sortie doit être du même type que y *)
```

## 4.2 Les GADTs et les types option et result

On veut maintenant coder une fonction qui fait avancer le robot de n cases en avant.
Le problème, c'est qu'il est possible que le robot sorte du terrain à la fin du
déplacement. La signature de `aller_tout_droit` dit qu'elle renvoie un `robot`,
et il n'existe pas de `null` dans un langage fonctionnel, donc on est obligé de
renvoyer queleque chose, quoi qu'il arrive.

On pourrait renvoyer un booléen en même temps que le nouveau robot qui donnerai
un status sur la valeur de sortie, mais c'est pas super explicit et de toute façon
on a pas besoin de la valeur du robot si on sait qu'elle est invalide. On pourrait
créer un autre énum :

```ocaml
type maybe_robot =
	| Valide of robot
	| Erreur
```

Mais ça impliquerait définir un `maybe_<type>` pour tous les types existants, et
puisque les variantes d'enum ne sont pas liés à un espace de nom, il faudrait
toutes les préfixer pour éviter les conflits de nom.

Heureusement, on peut utiliser des `GADTs` (ou Generalized Algebraic Data Types),
ce sont des énums (ou structs) qui ont au moins une variante (ou champ) qui demande
un argument générique. Cela veut dire qu'on peut encapsuler une valeur de n'importe
quel type dans cet argument.

Un des GADT les plus courants en OCaml est le type `option` qui permet d'encapsuler
une valeur quand on sait que la fonction peut toujours en renvoyer une (donc une
fonction `impure`).

```ocaml
(* syntaxe : type <parametres> <nom_type> = ... *)
(* Le type option existe déjà, pas besoin de le réécrire *)
type 'a option =
	| Some of 'a
	| None

(* Le paramètre de type s'inscrit à gauche du GADT *)
let division_opt (valeur: float) (diviseur: float): float option =
	if diviseur = 0.
	then None
	else Some (valeur /. diviseur)
```

Remarque : quand on mélange des tuples et GADT, ou des GADT de GADT, les règles
de priorités sont les suivantes :

- Les GADTs on priorité sur l'opérateur `*`, donc `int * int option` ce lit comme `int * (int option)`
- Les GADTs sont associatif à gauche, c'est à dire que `int option option` est équivalent à `(((int) option) option)`

Maintenant qu'on connait le type `option`, on peut écrire la fonction `aller_tout_droit`
de façon propre :

```ocaml
let aller_tout_droit (distance: int) (r: robot): robot option =
    let deplacement = vecteur_fois_int (direction_vers_vecteur direction) distance in
    let case_arrivee = translation_case deplacement position
    in
    if est_dans_terrain case_arrivee
    then Some { r with position = case_arrivee }
    else None
```

Maintenant, il faut adapter la fonction `effectue_action`, car elle est sensé
renvoyer un `robot`, mais une de ses branche en renvoie un `robot option`. On
va donc matche la sortie de `allet_tout_droit` et décrire quoi faire si on a une
valeur ou non (ici, on peut pas faire grand chose en cas de `None`, donc on va
planter le programme si on en a un)

```ocaml
let effectue_action (action: actions) (r: robot): robot =
    match action with
    | Avancer n_cases -> begin  (* on utilise begin … end pour délimiter le match imbriqué *)
        match aller_tout_droit n_cases r with
        | Some new_curiosity -> new_curiosity
        | None -> failwith "Le robot est sorti du terrain."
    end
    | Gauche -> position, tourner_gauche direction
    | Droite -> position, tourner_droite direction
```

On peut spécifier plusieurs paramètres de types dans la définition des GADTs,
par exemple, le type `result` est définit de la façon suivante :

```ocaml
(* Pareil, il existe déjà, ne le réimplémentez pas *)
type ('a, 'b) result =
	| Ok of 'a
	| Error of 'b
```

On se sert de `result` quand on veut encapsuler une valeur en cas d'erreur, et
pas juste dire "y'a pas de valeur", par exemple :

```ocaml
let division_res (valeur: float) (diviseur: float): (float, string) result =
	if diviseur = 0
	then Error "Division par 0"
	else Ok (valeur /. diviseur)
```

Note : le type `result` est 'deprecated' (obsolète) dans le module `Base`, si vous
avez importé ce module, il faudra alors utiliser `Result.t`. La définition et le
fonctionnement de ce type reste le même par contre.

La syntaxe est très similaires pour les structs :

```ocaml
type 'a with_id {
	id: int
	contents: 'a
}

let robot_identifie: robot with_id = {
	id = 69;
	contents = {
		nom = "Discovery";
		position = (12, 4);
		orientation = Sud;
	}
}
```
