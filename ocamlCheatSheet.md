# OCaml Cheat Sheet

---

## Types de donnés

### Types de données

`int` (nombre entiers)

`float` (nombre à virgule)

`bool` (true / false)

`char` (un seul caractère: 'a')

`str` (une chaîne de caractères: "AAAAAA")

`unit` (ne renvoie rien)

toujours faire très attentions au types utilisé.


### Caster un type dans un autre

```ocaml
float_of_int <int>      (* renvoie la même valeur mais en `float` *)
int_of_float <float>    (* renvoie la partie entière du float (entier arrondi en dessous) *)
string_of_int <int>     (* transforme un entier en une chaine de caractère *)
string_of_float <float> (* transforme un flotant en une chaine de caractère *)
```

### Les opérateurs

pour les int: `+`; `-`; `*` (multiplication); `/` (division)

pour les floats: parreil que pour les ints, mais suivis d'un point (ex: `+.`)

pour les bools: `||` (ou); `&&` (et); `not` (inverse la valeur du booléen)

comparaisons:  `=` (est égal à); `<>` (est différent à); `>` (suppérieur); `>=` (suppérieur ou égal); `<` (inférieur) `<=` (inférieur ou égal) (ces opérateurs renvoient des boolées).

pour les strings: `^` pour concaténer les chaines (les mettre bout à bout).

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

remarque: une variable est une fonction sans argument qui renvoie une constante.

### Déclarer une fonction

syntaxe: `let <nom_de_la_fonction> <arguments> : <type_de_sortie> = <expression>`

pour chaque argument, on fait `(<nom_argument>: <type_argument>)`

le type de sortie est le type de la valeur renvoyé.

exemple :

```ocaml
let carre (x: float) : float = x *. x
let estPair (x: int) : bool = (x mod 2 = 0) (*mod: division euclidienne de deux entiers*)
let moyenne (x: float) (y: float) : float = (x +. y) /. 2.0
let mesage : unit = Printf.printf "un message très utile \n%!"
;;
```

remarque : l'indentation et le retour à la ligne ne sont *techniquement* pas obligatoire mais sont très fortement conseillé pour rendre le programme plus lisible. On peut tout de même s'en passer quand la fonction est très simple (pas plus longue qu'une petite expression).

### Appeler une fonction

syntaxe : `<nom_de_la_fonction> <argument1> <argument2> ... <argumentn>`

appeler une fonction revient a utiliser une fonction prédéfinie, avec des variables donnés en entré.

**ATTENTION** ne pas mettre de parenthèses au tour des arguments, comme en python.

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

### Le rôle des parenthèses dans les appellations de fonctions

on utilise les parenthèses pour rendre explicite les cas où les variables ou fonctions passé en argument a une autre fonction sont ambigus. exemple :

```ocaml
moyenne carre -12.0 carre 17.0
(*
- -12.0 est vu comme un calcul et non un nombre négatif
- carre, -12.0, carre et 17.0 sont tous passé comme argument à moyenne, qui n'en demande que 2
- puisque -12.0 et 17.0 sont passé à moyenne, les deux carre n'ont pas d'arguments.
*)
moyenne (carre (-12.0)) (carre 17.0) (* ici, les arguments sont valides *)
```

remarques :
- les parenthèses dans `moyenne (4.0) (5.0)` sont redondantes car l'expression n'est pas ambigue.
- `moyenne (4.0 5.0)` va renvoyer une erreur car `4.0` et `5.0` sont vu comme un seul argument (voir tuples)

---

## Afficher un message dans la console

syntaxe: `Printf.printf "message" (<variable>)`

caractères utiles :

- `\n` revient à la ligne, souvent utilisé en fin de message.
- `%!` vide le buffer du print. Absolument **toujours** l'utiliser en fin de message. Ne pas le mettre veut dire ne jamais libérer la mémoire utilisé par le printf, donc de plus en plus de mémoire inutilement inutilisé après chaque printf. Non je sais pas pourquoi il faut le préciser.

pour insérer une variable dans le message, on écrit `%<première_lettre_du_type>`. Les variables vont être inséré dans l'ordre dont elles sont entré entre les parenthèses.

`Printf.printf` est de type unit.

exemples :

```ocaml
Printf.printf "Hello World!"
Printf.printf "%i\n%!" (12) (* écrit dans le terminal "12" *)
Printf.printf "x = %f et b = %b\n%!" (x b) (* écrit dans le terminal "x = 42.12 et b = false" *)
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
(* un if en une ligne, sans else *)
if estPair a then a + 1

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
	| _			                     -> <dernière expression>
```

toutes les expressions de sorties doivent renvoyer le même type.

le cas `_` va "récupérer" tous les cas non traité opparavent.

exemple, on verifie que le jour donné est possible :
		
```ocaml
(* une expression qui renvoit "true" si la date est valide et "false" dans le cas contraire *)
match m with
	| 1 | 3 | 5 | 7 | 8 | 10 | 12 -> (1 <= jour) && (jour <= 31)
	| 4 | 6 | 9 | 11			  -> (1 <= jour) && (jour <= 30)
	| 2                           -> (1 <= jour) && (jour <= 28)
	| _                           -> Printf.printf "le mois %i n'existe pas\n%!" (m); false
;;

(* voir la section 2 de "compositions de fonctions" pour l'explication du ";" *)
```

le pattern matching est une des notions fondamentales de la programation, ce n'es que les bases. Il y aura plus tard une explication plus poussée pour expliquer les cas plus complexes.

---

## Composition de fonctions

### Le mot clé `in`

syntaxe: `let <var/func> = <expression> and <var/func> = <expression> and ... in <expression>`

permet de faire de la composition de fonction (comme f•g en maths).

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

```ocaml
Printf.printf "le mois %i n'existe pas\n%!" (n); false (* écrit dans le terminal "le mois <n> n'existe pas" et renvoie "false" *)
message; message; moyenne 12 17 (* écrit deux fois de suite "un message très interessant" puis renvoie 14.5 (float) *)
```

---

## Types customs et tuples

### Définir un type custom

définir un type comme un alias d'un autre type peut permettre d'écrire un code plus simple à relire.

syntaxe : `type <nom_du_type> = <type>`

on peut aussi définir des types "énumérés". Les variables de ce type ne peuvent seulement valloir une des valeurs décrites:

syntaxe : `type <nom_du_type> = <constructeur 1> | <constructeur 2> | ... | <constructeur n>`

remarque : les constructeurs doivent **impérativement** commencer par une lettre majuscule.

exemples :

```ocaml
type batterie = float
type etat_machine = On | Off | Standby
;;
```

### Les tuples

on peut définir ce qu'on appelle un `tuple`, ce qui est une sorte de liste python mais qu'on ne peut pas modifier.

syntaxe : `let <nom_du_tuple> = (<var1>, <var2, ... <varn>: <type1> * <type2> * ... * <typen>)`

les tuples sont utiles pour stoquer un groupe de données, mais permettent surtout de renvoyer plusieures variables en même temps avec une seule fonction.

il est possible (et conseillé) de séparer la définition des type d'un tuple de la définition de ses éléments.

exemple de types customs et tuples dans un petit programme :

```ocaml
(* calcule l'heure une seconde après l'heure actuelle *)

type seconde = int
type minute = int
type heure = int
type meridien = Am | Pm
type horaire = heure * minute * seconde * meridien

let horaire_suivant (h, m, s, mer: horaire) : horaire = 
	if s = 59 then
		if m = 59 then
			if h = 11 then
				if mer = Am then
					(0, 0, 0, Pm)
				else
					(0, 0, 0, Am)
			else
				(h+1, 0, 0, mer)
		else
			(h, m+1, 0, mer)
	else
		(h, m, s+1, mer)
;;
```

remarque : il est impossible de directement afficher la valeur d'un `tuple` ou d'un type énuméré dans le terminal. Il faut soit même créer une fonction pour caster son `tuple` / `enum` en un `string`

exemple :

```ocaml
let string_of_horaire (h, m, s, mer: horaire) : string =
	(* les matchs expressions sont parfaites pour caster des enums *)
	let string_of_mer (m: meridien) =
		match m with
			| Am -> "Am"
			| Pm -> "Pm"
	in
	string_of_int h ^ ":" ^ string_of_int m ^ ":" ^ string_of_int s ^ ":" ^ string_of_mer mer
;;
```
