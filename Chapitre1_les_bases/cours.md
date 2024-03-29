# Chapitre 1 : Les bases

OCaml n'a pas de point d'entrée dédié, comme une fonction `main` en C, le langage
va juste évaluer les expressions dans l'ordre, du début jusqu'à arriver à la fin
du programme. La façon propre de démarrer le programme est avec l'expression
`let () = ...`. L'expression `()` (prononcé `unit`) ne demande pas d'arguments
donc son contenu va être évalué tout de suite. Elle ne porte pas de nom, donc
OCaml ne va pas chercher à l'utiliser plus tard, mais ça va imposer à son contenu
de renvoyer `unit`. (le type et la valeur `unit` sont la même chose, c'est un
ensemble vide donc ça représente la valeur 'rien').

# 1. Les types de données de base

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

# 2. Variables et fonctions

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
(* les arguments sont de la forme (<nom_arg>: type),
   ou juste <nom_arg> si leur type est inféré *)
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

Attention à ne pas commencer un nom de variable par une lettre en majuscule, il
n'y a que quelques outils en OCaml qui doivent commencer par une lettre majuscule.

## Cas particulier : Les fonctions sans arguments

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

# 3. Le rôle des parenthèses

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

# 4. Le rôle du point-virgule

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

# 5. Conditions simples avec `if`

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
