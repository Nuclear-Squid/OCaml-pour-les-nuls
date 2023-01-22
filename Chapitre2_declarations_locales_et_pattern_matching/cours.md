# Chapitre 2 : Définitions locales et pattern matching

# 1. Décomposition de valeurs

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

# 2. Ignorer des valeures lors de la décomposition

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

# 3. Déclarations locales

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
let <declaration_parente> =
	let <declaration_1> = <expr_1>
	and <declaration_2> = <expr_2>
	...
	and <declaration_n> = <expr_n>
	in
	<expression_suivante>
```

Les expressions définies dans un bloc `let ... in` ne peuvent être utilisé qu'a
la sortie de ce bloc, donc `let x = 12 and y = x + 1 in ...` est invalide, puisque
`x` n'existe pas dans le contexte de définition de `y`. Heureusement, l'expression
suivante peut être une autre déclaration locale, donc dans ce petit exemple, on peut
faire `let x = 12 in let y = x + 1 in ...`.

Avec des déclarations locales, on peut réécrire `ajoute_horraires` de cette façon :

```ocaml
(* Définition plus propre de ajoute_horraires *)
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
déjà spécifiés, et on ne fait que préciser ceux qu'ils manquent. Les applications
partielles sont une des notions les plus importantes en OCaml, donc on va y revenir.
Pour l'instant, souvenez vous juste que ça permet d'avoir un joli nom et des
arguments plus simples sur un cas particulier courant d'une fonction.

# 4. Match-Expressions

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
    let jour_valide borne_max jour : bool =
        1 <= jour && jour <= borne_max
    in 
    match mois with
    | 2                           -> jour_valide 28 jour
    | 4 | 6 | 9 | 11              -> jour_valide 30 jour
    | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> jour_valide 31 jour
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

`function` est juste du sucre syntaxique, donc vous pouvez l'ignorer si vous le voulez.
