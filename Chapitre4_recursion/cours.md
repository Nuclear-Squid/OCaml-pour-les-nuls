# Chapitre 4 : Récursion

Il y a un outil fondamental des langages impératifs dont on a pas encore vu
d'équivalent : les boucles. Bien qu’on ai des boucles `for` et `while` en OCaml,
ne pas avoir de variables mutables les rends assez inutiles. C'est pour ça qu'on
va voir les `fonctions récursives`, ça va nous permettre de remplacer complètement
les boucles en restant purement fonctionnel.

# 1. Une fonction récursive, c'est quoi ?

Une fonction récursive est une fonction qui s'appelle elle-même, ce qui va mettre
en pause l’évaluation de la fonction courante, évaluer une autre instance de cette
fonction avec de nouveaux paramètres, qui va renvoyer une valeur une fois qu’elle
a fini d’être évalué. Une fois que l’appel de niveau de récursion n + 1 à fini
d’être évalué, l’appel de niveau n pourra ensuite continuer son évaluation, avec la
valeur qu’a renvoyé la fonction de niveau n + 1.

Quand on écris une de ces fonctions, il y a trois paramètres à toujours caler *avant*
d'écrire quoi que ce soit :

1. Comment on traîte les arguments (comme avec n’importe quelle fonction)
2. Sous quelle(s) condition(s) sur les arguments on arrête la récursion
3. Quelles opérations on applique sur les arguments pour passer à l'état suivant.

Le premier point peut souvent être le plus compliqué à caler donc on va la garder
pour la fin.

Le deuxième est souvent similaire au fait de trouver la condition sous laquelle
on exécute le contenu d'une boucle `while`, par exemple "tant que x > 0, on fait
un appel récursif, sinon on s'arrête" (en général, on gère d'abbord le cas le
plus simple, pour des questions de lisibilité, et 99% du temps ça va être
l'expression qui arrête la récursion)

Le dernier paramètre est encore une fois similaire aux boucles while, il faut
savoir de quoi on aura besoin à l'etape suivante et vérifier que les modifications
nous dirige vers la condition d'arrêt.

On va maintenant prendre un exemple simple, une fonction qui affiche n fois un
message dans le terminal :

```ocaml
(* note : il faut préciser `rec` quand on défini une fonction récursive *)
let rec spam_message (n_messages: int) (message: string): unit =
	if n_messages <= 0  (* Condition d'arrêt *)
	then ()  (* Ne rien faire, ce qui arrête la récursion *)
	else begin
		printf "%s\n" message;  (* Traiter les paramêtres *)
		spam_message (n_messages - 1) message  (* Étape suivante *)
	end
```

Si `n_messages > 0`, la fonction va afficher le message dans le terminal, puis
faire un appel récursif avec `n_messages - 1`, ce qui va recommencer l'évaluation
de la fonction, le tout jusqu'a ce que `n_message = 0`, au quel cas on va tout
arrêter. Les arguments des fonctions étant des variables locales, les opérations
effectué au cours de l'évaluation de la fonction ne vont pas avoir d'impact sur
les instances parentes. On peut le voir en modifiant un peut la fonction pour
qu'elle affiche le nombre d'itérations restantes après l'appel récursif :

```ocaml
(* note : il faut préciser le `rec` quand on défini une fonction récursive *)
let rec spam_message (n_messages: int) (message: string): unit =
	if n_messages <= 0  (* Condition d'arrêt *)
	then ()  (* Ne rien faire, ce qui arrête la récursion *)
	else begin
		printf "%s\n" message;  (* Traiter les paramêtres *)
        spam_message (n_messages - 1) message;  (* Étape suivante *)
        printf "Itértions restantes : %d\n" n_messages  (* Les appels sont idédendants *)
    end
```

Une chose à noter, c'est que si on appelle la fonction on va avoir le nombre
d'itérations restantes affiché dans le sens inverse de ce à quoi on s'attends,
1 puis 2, puis 3…, c'est parce que quand on va faire l'appel récursif, l'exécution
de la fonction va totalement s'arrêter pour évaluer l'appel récursif avant de
continuer, donc l'évaluation de `spam_message 2 "Hello, World !!"` va ressembler à ça :

```
spam_message 2 "Hello, World !!":
	print "Hello, World !!"
	spam_message 1 "Hello, World !!":
		print  "Hello, World !!"
		spam_message 0 "Hello, World !!":
			<rien>
		print "1"
	print "2"
```

C'est pour ça que réussir à trouver comment traiter les données peut être compliqué,
il arrive souvent que pour calculer une valeur au niveau de récursion n, on ai besoin
de la valeur renvoyé par le niveau de récursion n + 1, par exemple, une fonction
factorielle :

```ocaml
let rec fac (n: int): int =
    if n <= 1  (* Condition d'arrêt *)
    then 1  (* arrêter la récursion en renvoyant 1 *)
    else n * fac (n - 1)  (* fac n dépends de la valeur de fac (n - 1) *)

(* trace :
fac 3 = 3 * (fac 2)
	  = 3 * (2 * (fac 1))
	  = 3 * (2 * 1)
	  = 3 * 2
	  = 6
```

Note: La console `utop` permet de générer des `traces` automatiquement, mais je les trouve
souvent difficiles à lire. De toute façon, je trouve que c’est plus important de
savoir utiliser un vrai débuggeur que des magouilles de console "top-level". Si jamais
le sujet vous interresse, je vous laisse un laisse cet [article](https://ocaml.org/docs/debugging)
des docs d’ocaml qui explique en détail les outils de debugging d’OCaml.

# 2. Types de données récursifs

On peut définir un énum ou struct de façon récursive, c'est à dire qu'au moins un
de ses champs ou argument de ses variantes est du type qu'on est en train de
définir. Comme pour les fonctions récursives il faut faire en sorte qu'on puisse
arrêter la récursion, avec généralement une variante non-récursive ou le champ
récursif encapsulé dans une `option`.

On va prendre un exemple très simple : un entier de Peano. C'est une des premières
façon de représenter les nombres entiers naturels en logique formelle, on a la
valeur 0 et on peut prendre son successeur (1), puis le successeur de son successeur
(2), et ainsi de suite. Compter avec un entier de peano revient à compter le nombre
de successeur.

```ocaml
(* Ne sait représenter que les entiers naturels *)
type peano =
    | Succ of peano (* contient Zero ou un autre Succ qui contiendra Zero ou… *)
    | Zero

(* transforme 2 en Succ (Succ Zero) *)
let rec peano_of_int (n: int): peano =
    if n <= 0
    then Zero
    else Succ (peano_of_int (n - 1))

(* transforme Succ (Succ Zero) en 2 *)
let rec peano_to_int = function
    | Zero -> 0
    | Succ p -> 1 + peano_to_int p
```

Un entier de peano seul ne sert pas à grand chose, donc on va définir un type
similaire dont la variante récursive va demander un argument générique supplémentaire :

```ocaml
type 'a pile =  (* Tous les éléments de la pile auront le même type *)
    | Elem of 'a * ('a pile)  (* attention à passer le paramètre à `pile` *)
    | Nil
```

Ce qu'on vient de réprésenter, c'est une sorte de pile de valeurs, un peu comme
une pile d'assiettes. On peut matcher la variante tout en haut de la pile, si on
a la variante `Elem`, on a accès à la valeur que l'élément contient et le reste
de la pile, et si on a `Nil`, on est arrivé à la fin de la pile et on a plus rien
à faire. Faisons une fonction qui affiche tous les éléments contenu dans une pile
d'entiers :

```ocaml
let rec affiche_pile_entier = function
    | Nil -> ()
    | Elem (valeur, suite) -> begin
        printf "%d\n" valeur;
        affiche_pile_entier suite
    end

let () = affiche_pile_entier (Elem (12, Elem (7, Elem ((-32), (Elem (42, Nil))))))
```

Ce type `pile` est très pratique, car en représentant le type sous forme "une
valeur puis le reste de la pile", on peut stocker un nombre indéfini de valeur
au sein d'une même variable. C'est tellement pratique qu'il existe déjà un
type `list` prédéfini en OCaml qui saura représenter ces `listes chaînées`
beaucoup mieux que ce qu'on ne pourrais jamais implémenter nous-même.

# 3. Les listes chaînées

Les `listes` (sous-entendu `chaînées`) sont principalement du sucre syntaxique sur
le type `pile` qu'on a défini plus tôt. Chaque élément (ou `nœud`) de la liste
contier une valeur et le reste de la liste. La syntaxe est la suivante :

- liste vide : `[]`
- valeur puis suivant : `<valeur> :: <suivant>`

On peut aussi définir une liste de façon un peu plus traditionnelle, en inscrivant
des valeurs entre des crochets, séparés par des `;`, et il existe l'opérateur `@`
qui sert à concaténer (mettre bout à bout) deux listes chainées. Toutes ces listes
chainées sont donc équivalentes :

```ocaml
let l1 = 1 :: (2 :: (3 :: []))
let l2 = 1 :: 2 :: 3 :: []  (* l'opérateur `::` est associatif à droite *)
let l3 = [1; 2] @ [3]
let l4 = 1 :: [2; 3]
let l5 = [1; 2; 3]
```

L'équivalence entre une l4 et l5 est très pratique dans les match-expressions, car
ça permet de séparer la tête de liste (le premier élément) du reste. On peut donc
réécrire `affiche_pile_entier` avec des listes chaînées :

```ocaml
let rec affiche_liste_entier = function
    | [] -> ()
    | valeur :: suite -> begin
        printf "%d\n" valeur;
        affiche_liste_entier suite
    end

(* On notera que la liste est beaucoup plus lisible que notre pile *)
let () = affiche_liste_entier [12; 7; -32; 42]
```

On peut aussi faire une fonction qui créé une liste chaînée, par exemple, on va
faire une fonction qui renvoie une liste de tous les nombres entiers compris dans
un intervale :

```ocaml
let rec make_range (borne_inf: int) (borne_sup: int): int list =
    if borne_inf > borne_sup
    then []
    else borne_inf :: make_range (borne_inf + 1) borne_sup
```

Un exemple de trace de cette fonction est :

```
make_range 4 7
	= 4 :: make_range 5 7
	= 4 :: 5 :: make_range 6 7
	= 4 :: 5 :: 6 :: make_range 7 7
	= 4 :: 5 :: 6 :: 7 :: make_range 8 7
	= 4 :: 5 :: 6 :: 7 :: []
	= [4; 5; 6; 7]
```

Remarque : Il arrive que la liste ne sorte pas dans le bon sens quand on fait
une fonction récursive, au quel cas il est tentant d'utiliser l'opérateur `@`
pour faire des ajouts en queue (c'est-à-dire construire la liste chaînée en
ajoutant les éléments à la fin de la liste à chaque étape), plutôt que des
ajouts et tête (ajouter les éléments au début). Cela va effectivement résoudre
le problème immédiat, mais je déconseille cette aproche car l'opérateur `@` est
très inéficace et on peut avoir des grosses pertes de performances quand on
traîte des longues listes. On étudiera ça en détail dans le chapitre suivant,
avec la notion de `tail recursion`.

# 4. Utiliser des accumulateurs

Parfois, on veut pouvoir sauvegarder des informations sur un nombre indéfini
d’étape dans la récursion. Une stratégie très courante, est de coder la fonction
récursive avec tous les paramètres dont on a besoin et de la «cacher» dans une
fonction qui ne demande que les paramètres importants. Ces paramètres cachés
peuvent être assimilé à des «accumulateurs», qui vont petit à petit ce remplir
jusqu’à être vidé et envoyé à l’expression globale.

Par exemple, la fonction factorielle peut être écrite de cette façon :

```ocaml
let fac (n: int) =
	let rec loop (acc: int) (n: int) =
		match n with
		| 0 | 1 -> acc
		| n -> loop (acc * n) (n - 1)
	in
	loop 1 n
```

Ici, on a pas vraiment d’information supplémentaire à représenter dans le nom
du corps de la fonction, ni dans le nom de l’accumulateur donc on peut se permettre
de les appeler `loop` et `acc` respectivement.

Dans cet exemple, on a pas vraiment besoin d’utiliser un accumulateur, mais c’est
souvent impossible (ou très compliqué) de faire sans. Par exemple, on va coder une
fonction qui prends une liste d’entiers en entrée, et renvoie une liste de
la somme de tous les entiers consécutifs du même signe.
Par exemple : `somme_meme_signe [1; 2; -4; 5; -1; -6] = [3; -4; 5; -7]`.

```ocaml
let somme_meme_signe (input: int list): int list =
    let meme_signe a b = a * b >= 0
	in
    let rec loop (acc: int) = function
        | [] -> []
        | [last] -> if meme_signe last acc
            then [acc + last]
            else [acc ; last]
        | hd :: tl -> if meme_signe hd acc
            then loop (hd + acc) tl
            else acc :: loop hd tl
    in
    loop 0 input
```

Ici, ça serait très compliqué de se passer de l’accumulateur, car on ne sait pas
combien d’entiers de même signe consécutifs on va avoir.

Il reste encore beaucoup de choses à étudier sur les fonctions récursives, donc
le chapitre suivant sera dédié à toutes les notions qu’on a pas eu le temps
d’étudier ici, comme les fonctions `mutuellement récursives`, les `arbres` et une
technique d’optimisation appelé la `tail recursion`.
