# Chapitre 0 : Préliminaires

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
