# OCaml pour les nuls

---
## Table des matières

0. [Préliminaires](#0-préliminaires)
1. [Les bases](#1-les-bases)
	1. [Les types de données de base](#11-les-types-de-données-de-base)
	2. [Variables et fonctions](#12-variables-et-fonctions)
	3. [Le rôle des parenthèses](#13-le-rôle-des-parenthèses)
	4. [Le rôle du point-virgule](#14-le-rôle-du-point-virgule)
	5. [Conclusion](#15-conclusion)
---

# 0. Préliminaires

Commencez bien-évidemment par installer OCaml, la façon recommandé est de passer
par [opam](https://opam.ocaml.org/doc/Install.html), le gestionnaire de paquet
d'OCaml, puis l'utiliser pour installer : la dernière version d'OCaml et
[dune](https://dune.build/), un des compilateur les plus populaires.

Une fois que tout ça a été installé, lancez un terminal, allez dans le dossier
dans lequel vous voulez stocker les tests que vous écrirez pendant ce tutoriel
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
de la stdlib qui est beaucoup plus propre que l'API par défaut) et `Stdio` (qui
permet d'avoir des vrais print et pas l'horreur qu'est le système par défaut).
Pour pouvoir utiliser stdio, il faut le rajouter dans les librairies utilisé
dans le fichier `playground/bin/dune`. Base est disponible par défaut.

Le nouveau fichier de base devrait ressembler à ça :

```ocaml
open Base
open Stdio

let _ = 2 ** 6 (* rustine pour *techniquement* utiliser Base *)

let () = printf "Hello, world !!\n"
```

**Tous** les exemples de code de ce tuto sont écris en partant du principe que
ces deux librairies sont utilisés. Vous pourrez trouver une documentation de
la librairie `Base` [ici](https://ocaml.janestreet.com/ocaml-core/v0.13/doc/base/Base/index.html)

# 1. Les bases

OCaml n'a pas de point d'entrée dédié, comme une fonction `main` en C, le langage
va juste évaluer les expressions dans l'ordre dans lesquels ils les lis jusqu'à
arriver à la fin du programme. La façon propre de démarrer le programme est avec
l'expression `let () = ...`. L'expression ne demande pas d'arguments donc son
contenu va être évalué tout de suite, l'expression à forcément type `unit`, et
vu qu'elle n'a pas de nom, le fait qu'on ne l'utilise pas ailleurs ne pose pas
de problèmes.

## 1.1. Les types de données de base

```
+--------+----------------------+------------------------+-----+
| Nom    | Description          | Operateurs             | fmt |
+========+======================+========================+=====+
| int    | nombre entiers       | +  -  *  /  **  ~- mod | %d  |
| float  | nombre à virgule     | +. -. *. /. **. ~-.    | %f  |
| bool   | true / flase         | ||  &&  not            | %b  |
| char   | un caractère: 'a'    | <rien>                 | %c  |
| string | chaîne de caractères | ^ (concaténation)      | %s  |
| unit   | (ne renvoie rien)    | <rien>                 |     |
+--------+----------------------+------------------------+-----+
```

Les opérateurs de comparaison sont :

- `=` (est égal à)
- `<>` (est différent à)
- `>` (suppérieur)
- `>=` (suppérieur ou égal)
- `<` (inférieur)
- `<=` (inférieur ou égal)
- (ces opérateurs renvoient des boolées).


note: `~-` et `~-.` renvoient l'opposée de la valeur

fmt est le format a utiliser pour insérer une valeur dans un print. Pour plus
d'informations, regardez la [doc](https://ocaml.janestreet.com/ocaml-core/v0.13/doc/base/Base/Printf/index.html)

## 1.2. Variables et fonctions

OCaml est un langage fonctionnel, donc les variables sont immuables, c'est-à-dire
qu'on ne peut pas les modifier. C'est parce que les variables de bases et les
fonctions sont en fait des expressions, qu'on déclare avec le mot clé `let`.

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
let moyenne a b = (a +. b) /. 2
(* On peut aussi inférer le type des args et de sortie des fonctions *)
```

Pas besoin de mot-clé en particulier pour renvoyer une valeur, une fonction va
implicitement renvoyer la sortie de l'expression évaluée

Pour appeler une fonction, il suffit d'écrire le nom de la fonction, puis donner
les arguments séparés par un espace. Par exemple `double x` va renvoyer 138, et
`moyenne y z` va renvoyer 23.06.

## 1.3. Le rôle des parenthèses

On utilise les parenthèses pour rendre explicite les cas où l'ordre d'évaluation
des arguments est ambiguë. Par exemple :

```ocaml
moyenne Float.of_int double 12 -5.
(*
- <expression> - 5. est vu comme un calcul et non le nombre -5 passé en argument
- Float.of_int et double sont passé en argument à moyenne en même temps que 12,
    ce qui veut dire que ces fonctions n'ont reçu aucun arguments.
*)
moyenne (Float.of_int (double 12)) (-5.) (* ici, les arguments sont valides *)
```

On utilise aussi `()` en tant qu'argument de fonction quand la fonction ne demande
aucun argument, car une expression qui ne demande pas d'argument va avoir le côté
droit de l'équation évalué tout de suite, même si on n'appelle pas la fonction.
(Rappel : c'est ça qui perment à `let () = ...` d'être un point d'entrée, la
fonction de demande pas d'arguments donc son contenu est évalué tout de suite).

```ocaml
let message () = printf "Ceci est mon tout premier programme OCaml !!\n"
```

si on retire `()`, non seulement le message va apparaître dans la console quoi
avant d'arriver au point d'entrée principal, mais l'expression va être considéré
comme une variable, donc on cherche à stocker la sortie de `printf`, qui est de
type `unit`. Ça implique que `message` ne stock `<rien>`, et essayer d'utiliser
`message` ne fera rien.

## 1.4. Le rôle du point-virgule

Le point-virgule permet de séparer des expressions qui renvoient `unit`, pour
pouvoir les enchaîner. Ça ne permet **pas** de définir une variable locale, on
verra dans le chapitre 2 comment faire ça. On va voir ici comment on peut s'en
servir pour executer plusieurs prints :

```ocaml
message ();
printf "42 * 2 = %d\n" (double 42);
printf "La moyenne de 16.5 et 23.75 est %f\n" (moyenne 16.5 23.75)
```

(Attention a ne pas mettre de `;` sur la dernière ligne, sinon la définition de
fonction n'es jamais terminée)

## 1.5. Conclusion

Pour l'instant on sait faire des fonctions de bases et afficher le résultat
dans la console. Le chapitre suivant porte sur les définitions locales et le
pattern matching. Vous pourrez aussi retrouver (comme pour tous les autres
chapitres) un fichier `.ml` qui utilise toutes le notions vu au cours du
chapitre dans le dossier `ExemplesFinChapitres`.
