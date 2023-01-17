# OCaml pour les nuls

---
## Table des matières

0. [Préliminaires](#0-préliminaires)
1. [Les bases](#1-les-bases)
	1. [Les types de données de base](#11-les-types-de-données-de-base)
	2. [Variables et fonctions](#12-variables-et-fonctions)
	3. [Le rôle des parenthèses](#13-le-rôle-des-parenthèses)
	4. [Le rôle du point-virgule](#14-le-rôle-du-point-virgule)
	5. [Conditions simples avec `if`](#15-conditions-simples-avec-if)
	6. [Conclusion](#16-conclusion)
2. [Définitions locales et pattern matching](#2-définitions-locales-et-pattern-matching)
	1. [Décomposition de valeurs](#21-décomposition-de-valeurs)
	2. [Ignorer des valeures lors de la décomposition](#22-ignorer-des-valeures-lors-de-la-décomposition)
	3. [Définitions locales](#23-définitions-locales)
	4. [Match-Expressions](#24-match-expressions)
---

# 0. Préliminaires

Commencez bien-évidemment par installer OCaml, la façon recommandé est de passer
par [opam](https://opam.ocaml.org/doc/Install.html), le gestionnaire de paquet
d'OCaml, puis l'utiliser pour installer, la dernière version d'OCaml et
[dune](https://dune.build/), un des compilateur les plus populaires.

Une fois que tout ça a été installé, lancez un terminal, allez dans le dossier
dans lequel vous voulez stocker les programmes que vous écrirez pendant ce tutoriel
et lancez la commande `dune init project playground` (vous pouvez changer le nom
`playground` par celui que vous voulez, c'est juste un example). Vous allez avoir
beaucoup de nouveaux fichiers et dossiers, mais le plus important est le fichier
`playground/bin/main.ml`, c'est ici que votre programme principal est stocké.

Vérifiez que tout fonctionne en lançant la commande `dune build` pour compiler
le programme. Si aucun message d'erreur s'affiche, vous pouvez lancer
`dune exec playground` pour executer votre programme.

(ps: au moment où j'écris ce passage, dune a un léger bug qui fait que les infos
de build ne disparaissent pas avant d'executer le programme, si c'est le cas chez
vous, vous pouvez lancer à la place `dune build && ./_build/default/bin/main.exe`)

## Avant de rentrer dans le vif du sujet

Je recomande de toujours utiliser les librairies `Base` (une réécriture de l'API
de la stdlib qui est beaucoup plus propre que l'API par défaut), `Stdio` (qui
permet d'avoir des vrais print et pas l'horreur qu'est le système par défaut),
et `Poly`, qui permet d'avoir des opérateurs de comparaisons polymorphiques (qui
marchent sur plusieurs types de données). Pour pouvoir utiliser ces libs, il faut
les déclarer dans le fichier `playground/bin/dune`. `Poly` est un sous-module de
`Base`, donc il faudra le déclarer après `Base`.

Le nouveau fichier de base devrait ressembler à ça : (dans ce micro-exemple, on
a pas besoin de `Base` et `Poly`, donc on peut les laisser en commentaires)

```ocaml
(* open Base *)
open Stdio
(* open Poly *)

let () = printf "Hello, world !!\n"
```

**Tous** les exemples de code de ce tuto sont écris en partant du principe que
ces deux librairies sont utilisés. Vous pourrez trouver une documentation de
la librairie `Base` [ici](https://ocaml.janestreet.com/ocaml-core/v0.13/doc/base/Base/index.html)

---

# 1. Les bases

OCaml n'a pas de point d'entrée dédié, comme une fonction `main` en C, le langage
va juste évaluer les expressions dans l'ordre, du début jusqu'à arriver à la fin
du programme. La façon propre de démarrer le programme est avec l'expression
`let () = ...`. L'expression `()` (prononcé `unit`) ne demande pas d'arguments
donc son contenu va être évalué tout de suite. Elle ne porte pas de nom, donc
OCaml ne va pas chercher à l'utiliser plus tard, mais ça va imposer à son contenu
de renvoyer `unit`. (le type et la valeur `unit` sont la même chose, c'est un
ensemble vide donc ça représente la valeur 'rien').

## 1.1. Les types de données de base

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

Les opérateurs de comparaison sont : `=` (est égal à), `<>` (est différent à)
et `>` `>=` `<` `<=`, qu'on retrouve dans tous les autres langages de prog.

remarque: Souvenez vous, `Poly` permet d'utiliser les opérateurs de comparaison
sur n'importe quel type de données.

note: `~-` et `~-.` renvoient l'opposée de la valeur.

fmt est le format a utiliser pour insérer une valeur dans un print. Pour plus
d'informations, regardez la [doc](https://ocaml.janestreet.com/ocaml-core/v0.13/doc/base/Base/Printf/index.html)

Pour les flotants, il existe beaucoup de façon de les inscrires, mais `%g` choisi
automatiquement le format le plus adapté, donc en général on peut l'utiliser sans
se poser trop de questions.

## 1.2. Variables et fonctions

OCaml est un langage fonctionnel, donc les variables sont immuables, c'est-à-dire
qu'on ne peut pas les modifier. C'est parce que les variables de bases et les
fonctions sont en fait des expressions, qu'on déclare avec le mot clé `let`. Une
variable est donc juste une fonction sans argument qui renvoie directement une valeur.

On peut déclarer une variable de la façon suivante :

```ocaml
(* syntaxe: let <nom_variable> : <type> = <valeur> *)
let x: int = 42
let y: float = 16.5
let z = 23.75
(* le type peut être inféré, ici z est un float *)
```

Et une fonction de la façon suivante :

```ocaml
(* syntaxe: let <nom_fn> <args> : <type_sortie> = <expr> *)
let double (n: int): int = n * 2

(* On peut inférer chaque argument et sortie de fonction indépendemment *)
let moyenne a b: float = (a +. b) /. 2.  (* 2. = 2.0 *)

(* Voir tout inférer quand c'est évident *)
let entier_est_pair n = n % 2 = 0
```

Pas besoin de mot-clé en particulier pour renvoyer une valeur, une fonction va
implicitement renvoyer la sortie de l'expression évaluée

Pour appeler une fonction, il suffit d'écrire le nom de la fonction, puis donner
les arguments séparés par un espace. Par exemple `double x` va renvoyer 138, et
`moyenne y z` va renvoyer 23.06.

### Cas particulier : Les fonctions sans arguments

On utilise aussi `unit` en tant qu'argument de fonction quand la fonction ne demande
aucun argument, car une expression qui ne demande pas d'argument va avoir le côté
droit de l'équation évalué tout de suite, même si on n'appelle pas la fonction.
(Rappel : c'est ça qui perment à `let () = ...` d'être un point d'entrée, la
fonction de demande pas d'arguments donc son contenu est évalué tout de suite).

```ocaml
let message () = printf "Ceci est mon tout premier programme OCaml !!\n"
```

si on retire `()`, non seulement le message va apparaître dans la console avant
même d'arriver au point d'entrée principal, mais l'expression va être considéré
comme une variable, donc on cherche à stocker la sortie de `printf`, qui est de
type `unit`. Ça implique que `message` stoque `unit` (soit la valeur 'rien'), et
essayer d'utiliser `message` ne fera rien.

## 1.3. Le rôle des parenthèses

On utilise les parenthèses pour rendre explicite les cas où l'ordre d'évaluation
des arguments est ambiguë. Par exemple :

```ocaml
let pythagore (cote1: float) (cote2: float): float =
	Float.sqrt cote1 **. 2. +. cote2 **. 2.
```

Cette expression va être compilé sans problèmes, mais les résultats sont… surprenant.
En effet, `pythagore 3. 4.` va renvoyer `19.`. Le problème ici est que les arguments
de l'expression ne sont pas évalués dans le bon ordre. Les opérateurs mathématiques
séparent les expressions, chaque côté de l'opérateur va être évalué indépendemment,
puis le calcul global est évalué.

Notre implémentation de pythagore est donc équivalente à ça :

```ocaml
let pythagore (cote1: float) (cote2: float): float =
	((Float.sqrt cote1)) **. (2.) +. ((cote2) **. (2.))
```

Pour corriger le problème, on peut manuellement inscrire les parenthèses nous-même :

```ocaml
let pythagore (cote1: float) (cote2: float): float =
	Float.sqrt (cote1 **. 2. +. cote2 **. 2.)
```

## 1.4. Le rôle du point-virgule

Le point-virgule permet de séparer des expressions qui renvoient `unit`, pour
pouvoir les enchaîner. Ça ne permet **pas** de définir une variable locale.
On va voir ici comment on peut s'en servir pour executer plusieurs prints :

```ocaml
let () =
	message ();
	printf "42 * 2 = %d\n" (double 42);
	printf "La moyenne de 16.5 et 23.75 est %f\n" (moyenne 16.5 23.75)
```

(Attention a ne pas mettre de `;` sur la dernière ligne, sinon la définition de
fonction n'es jamais terminée)

## 1.5. Conditions simples avec `if`

Oui il y a des `if` en OCaml, c'est en général pas la meilleur façon de tester
une condition, mais ça suffit amplement quand on veut tester des choses simples,
typiquement une expression booléenne.

```ocaml
(* Syntaxe : if <condition> then <expr_true> else <expr_false> *)
let signe_entier n =
    if n = 0
    then "Zéro"
    else if n > 0
        then "Positif"
        else "Négatif"
```

Il n'existe pas d'équivalent de `elif` en OCaml, donc si on veut en faire un, il
faut imbriquer un autre `if` dans de bloc `else`, ce qui est globalement très
moche, donc on verra dans le chapitre 2 des façon plus propre de tester pleins
des conditions à la suite à l'aide du `pattern matching`.

Il est possible de ne pas mettre de bloc `else`, mais il faut que l'expression
dans le bloc `then` renvoie `unit`, par exemple :

```ocaml
(* La fonction failwith fait planter le programme avec le message d'erreur donné *)
let assert_ue_bien_enseigne (ue: string): unit =
    if String.lowercase ue = "inf201"
    then failwith "Non, l'ue inf201 est pas bien enseigne."

```

## 1.6. Conclusion

Pour l'instant on sait faire des fonctions de bases et afficher le résultat
dans la console. Le chapitre suivant porte sur les définitions locales et le
pattern matching.

Vous pourrez aussi retrouver (comme pour tous les autres chapitres) un fichier
`.ml` qui utilise toutes le notions vu au cours du chapitre dans le dossier
`ExemplesFinChapitres`.

---

# 2. Définitions locales et pattern matching

## 2.1. Décomposition de valeurs

Les expressions ne sont pas limité à renvoyer une seule valeur, elles peuvent
renvoyer un 'assemblage' de valeurs plus ou moins complexe pour envoyer le plus
d'information possible d'un coup. Par exemple, une expression peut renvoyer un
tuple (ensemble fini de valeurs) :

```ocaml
(* Represente un horraire au format heure, minute, seconde *)
let horraire_alarme = (6, 30, 00)
```

(Pour l'instant on va garder les types de ces variables inféré, on verra comment
les spécifiers au chapitre suivant)

Ici, `horraire_alarme` va contenir un ensemble de valeurs, mais imaginons qu'on
veut afficher l'heure à laquelle l'alarme va sonner, on peut pas juste passer
cette variable a `printf` puisque elle attends des valeurs simples, et non un
tuple. On va donc chercher à décomposer ce tuple en valeurs simples :

```ocaml
(* On décompose le tuple horraire_alarme en éléments simples *)
let (alarme_heure, alarme_minute, alarme_seconde) = horraire_alarme
```

C'est pour ça qu'on appelle souvent les déclarations des "équations", c'est que
le côté gauche du `=` est aussi très important. Dans le premier exemple, on a juste
dit "on a une variable, qui contient cette valeur", cette valeur peut être absolument
tout ce qu'on veut et ici c'était un tuple de trois entiers. Dans le deuxième
exemple on a été plus précis, on a dit "on a un tuple de trois éléments, nommé
`alarme_heure`, `alarme_minute` et `alarme_seconde` qui ensemble doivent être
égal à `horraire_alarme`.

On va souvent dire que la partie gauche d'une déclaration est un `pattern`.

Cette décompositions de valeurs peut aussi être effectué dans les définitions de
fonctions, si on cherche à décomposer un de ses arguments :

```ocaml
(* On peut décomposer des valeurs valeurs passer en arguments directement dans
   la définition de la fonction *)
let affiche_horraire (heures, minutes, secondes) =
    printf "Horraire : %dh%d:%d.\n" heures minutes secondes

```

## 2.2. Ignorer des valeures lors de la décomposition

Imaginons maintenant qu'on a vraiment pas besoin de récupérer les secondes dans
l'horraire de l'alarme. On ne peut pas juste demander un ensemble de deux éléments
dans la partie gauche de l'équation, puisque qu'on a un ensemble de trois éléments
à droite. Le pattern serait donc incompatible avec la valeur à décomposer, et le
programme ne pourra pas être compilé.

Ce qu'on peut faire, c'est remplasser `alarme_seconde` par `_`, cela permet de
dire au compilateur que normalement il y a une valeur ici, mais on en a pas
besoin donc on lui donne pas de nom. Par exemple :

```ocaml
(* On décompose le tuple horraire_alarme en éléments simples *)
let (alarme_heure, alarme_minute, _) = horraire_alarme

let () = printf "Le réveil va sonner à %dh%d.\n" alarme_heure alarme_minute
```

Note : dans les cas où ce n'est pas évident ce que le champ ignoré est sensé
représenter, on peut lui donner un nom, mais préfixé par un `_`, pour dire qu'on
fait exprès de ne pas l'utiliser. Le compilateur sait reconnaître cette syntaxe
et ne va pas donner d'avertissements. Par exemple :

```ocaml
(* Décomposition plus explicite *)
let (alarme_heure, alarme_minute, _alarme_secondes) = horraire_alarme

let () = printf "Le réveil va sonner à %dh%d.\n" alarme_heure alarme_minute
```

## 2.3. Définitions locales

Imaginons maintenant qu'on veut implémenter une fonction `snooze`, qui va ajouter
5 minutes à l'heure actuelle. Ajouter 5 minutes est juste un cas particulier
d'ajouter deux heures entre elles, donc on va d'abord implémenter la fonction
`ajoute_horraires` qui prends en entrée deux horraires et en renvoie leur somme :

```ocaml
let ajoute_horraires (heures1, minutes1, secondes1) (heures2, minutes2, secondes2) = (
        (heures1 + heures2 + ((minutes1 + minutes2 + ((secondes1 + secondes2) / 60)) / 60)) % 24,
        (minutes1 + minutes2 + ((secondes1 + secondes2) / 60)) % 60,
        (secondes1 + secondes2) % 60
    )
```

Ok, c'est dégueulasse. L'expression est bien trop complexe pour pouvoir être
exprimmé en une seule fois, et même si cette fonction à priori fonctionne, cela
demande beaucoup d'effort pour comprendre son fonctionnement, ce qui peut la
rendre très compliqué à modifier en cas de problèmes.

On va donc séparer l'expression en plusieures étapes qui vont toutes faire une
chose simple. Pour le faire on peut utiliser la syntaxe suivante :

```ocaml
(* On peut mettre autant de `and` que l'on veut, y compris 0 *)
let <expression_parente> =
	let <pattern_1> = <expr_1>
	and <pattern_2> = <expr_2>
	...
	and <pattern_n> = <expr_n>
	in
	<expression_suivante>
```

Les expressions définies dans un bloc `let ... in` ne peuvent être utilisé qu'a
la sortie de ce bloc, donc `let x = 12 and y = x + 1 in ...` est invalide, puisque
`x` n'existe pas dans le contexte de définition de `y`. Heureusement, l'expression
suivante peut être une autre déclaration locale, donc dans ce petit exemple, on peut
faire `let x = 12 in let y = x + 1 in ...`.

Avec des définitions locale, on peut réécrire `ajoute_horraires` de cette façon :

```ocaml
(* Définition plus propre de ajoute_horraires *)
let ajoute_horraires horraire1 horraire2 =
    let (heures1, minutes1, secondes1) = horraire1
    and (heures2, minutes2, secondes2) = horraire2
    in
    let nouvelles_secondes = (secondes1 + secondes2) % 60
    and minutes_a_rajouter = (secondes1 + secondes2) / 60
    in
    let nouvelles_minutes = (minutes1 + minutes2 + minutes_a_rajouter) % 60
    and heures_a_rajouter = (minutes1 + minutes2 + minutes_a_rajouter) / 60
    in
    let nouvelles_heures = (heures1 + heures2 + heures_a_rajouter) % 60
    in
    (nouvelles_heures, nouvelles_minutes, nouvelles_secondes)
```

Certes, la définition de la fonction est beaucoup plus longue, mais à chaque
étape, on sait exactement ce qu'il se passe, le code est beaucoup plus explicit
et beaucoup plus simple à modifier plus tard, si on veut corriger un bug ou ajouer
une fonctionnalité.

On peut maintenant facilement implémenter notre fonction `snooze` :

```ocaml
(* Pas besoin de décompser alarme, car on veut juste la transmettre à ajoute_horarires *)
let snooze alarme = ajoute_horraires alarme (0, 5, 0)
```

On peut dire que `snooze` est une `application partielle` de `ajoute_horraires`,
car c'est comme si on appelait `ajoute_horraires` avec une partie des arguments
déjà spécifiés, et on ne fait que préciser ceux qu'il manque. Les applications
partielles sont une des notions les plus importantes en OCaml, donc on va souvent
y revenir. Pour l'instant, souvenez vous juste que ça permet d'avoir un joli nom
et des arguments plus simples sur un cas particulier courant d'une fonction.

## 2.4. Match-Expressions

Il est possible d'inscrire des valeures en dur dans un pattern quand on cherche
à décomposer une valeur, par exemple, `let (12, minutes, secondes) = horraire_alarme`
est techniquement un pattern valide. Le problème est qu'on ne peut pas garantir
que le premier élément de `horraire_alarme` soit 12, donc ce pattern n'es pas
exhaustif, et le compilateur va refuser de compiler en donnant un avertissement.

Ce qu'on peut faire, c'est avoir une série de patterns non-exhaustifs qui tous
ensemble recouvrent tous les cas de figures possibles (ou avoir un cas exhaustif
à la fin, quand on a une infinité de cas, aussi appelé wildcard), et les tester
un par un jusqu'a en trouver un qui marche. C'est exactement ce que fait une
`match-expression` :

```ocaml
(* Syntaxe : *)
match <expresion> with
| <pattern_1> -> <expr_1>
...
| <pattern_n> -> <expr_n>
```

Par exemple, faisons une fonction qui vérifie que c'est l'heure du déjeuner :

```ocaml
(* Les matchs peuvent décomposer une valeur et tester une égalité en même temps *)
let peut_dejeuner horraire =
	match horraire with
	| (12, _, _) -> true
	| _          -> false
```

Ici on a pu décomposer l'horraire *et* vérifier que l'heure est égale à 12 en même
temps, car si l'heure dans `horraire` vaut 12, alors le premier pattern est valide,
et l'expression associé est évaluée. Le deuxième pattern est un wild card, qui va
récupérer n'importe quel tuple qui n'es pas décomposable par les patterns précédents.

Il est possible d'associer une même expression à plusieurs patterns en les
séparant par un `|`, par exemple dans la ligne `| 1 | 2 | 3 -> <expr>`, expr va
être évaluer quand la valeur matché est 1, 2 ou 3. On va commencer par un cas
simple, vérifier qu'une date composée d'un mois et d'un jour est valide :

```ocaml
let date_valide (mois: int) (jour: int): bool = 
    let jour_compris_dans borne_max jour : bool =
        1 <= jour && jour <= borne_max
    in 
    match mois with
    | 2                           -> jour_compris_dans 28 jour
    | 4 | 6 | 9 | 11              -> jour_compris_dans 30 jour
    | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> jour_compris_dans 31 jour
    | _ -> false  (* mois invalide *) 

```

Ici, on compare le mois avec un nombre fini ne valeur entière. Quand on trouve
une valeur égale au mois, on évalue l'expression associé, qui dans notre cas va
verifier que jours est compris entre 1 et la borne max. Si on ne trouve pas de
valeur égales au mois dans les patterns, on tombe dans la wild card, et on
revoie `false` tout de suite.

On peut aussi ajouter une condition au pattern avec le mot clé `when`, pour
n'évaluer l'expression associé que si le pattern est valide *et* que la condition
est validé. Par exemple, réimplémentons la fonction `signe_entier` du chaitre 1 :

```ocaml
let signe_entier n =
	match n with
	| 0            -> "Zéro"
	| n when n > 0 -> "Positif"  (* Ici on redéfini n, ce qui est pas très grave *)
	| _            -> "Négatif"  (* utilisez des espaces pour l'allignement
	                                vertical, jamais des tabs, sinon ça peut
									changer d'un ordi a un autre *)
```

Utiliser une match-expression ici nous a permis de se débarasser des `if`
imbriqués, donc on évite d'avoir du code exponentiellement plus dur à modifier
quand le nombre de conditions augmente

Attention à bien mettre la branche conditionnelle *avant* la wildcard, sinon on
ne pourra jamais atteindre la branche conditionnelle.

Ce genre de fonctions qui ne sont en fait qu'une match expressions sont tellement
courantes, qu'on a un alias pour ça. On peut retirer l'argument qu'on veut matcher
puis inscrire `function` après le `=`, ça fait la même chose mais ça permet d'être
un peu plus concis quand l'argument à matcher est évident. L'argument a matcher
sera le dernier à être précisé :

```ocaml
let signe_entier = function
	| 0            -> "Zéro"
	| n when n > 0 -> "Positif"
	| _            -> "Négatif"
```

Pour l'instant c'est juste du `function` est juste du sucre syntaxique, donc vous
pouvez l'ignorer si vous en avez envie.
