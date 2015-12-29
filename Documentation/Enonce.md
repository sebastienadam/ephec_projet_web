# Projet de développement Web

Il faut:

1. créer un site web en utilisant le modèle MVC.

1. créer sa propre méthode d'authentification avec des rôles (RBAC). Les données d'authentification sont un e-mail et un mot de passe. Les rôles minimums sont "utilisateur" et "administrateur". Un utilisateur doit pourvoir s'enregistrer sur le site. Il aura alors un rôle "utilisateur". L'administrateur peut modifier le rôle d'un utilisateur. La sécurité n'est pas un point essentiel (on peut stocker des mots de passe en clair, si on sait que ce n'est pas bien de le faire).

1. valider les données envoyée au site (côté client et côté serveur).

1. créer un attribut de validation personnalisé. Par exemple: un champ est requis si un autre a une valeur 'X'.

1. utiliser des requêtes AJAX avec données validées (côté client et côté serveur). Il faut également pouvoir expliquer ce qui a été fait.

1. pouvoir déterminer (et expliquer) quand utiliser un 'GET' et un 'POST' dans les requêtes AJAX.

1. créer des méthodes d'extension. Par exemple: créer une méthode qui formate une date de manière particulière. => propre à .NET

1. utiliser un contrôler de base et en faire bon usage.

1. utiliser un NuGet propre au MVC. Par exemple: DataTable qui permet de travailler avec JSON, faire des tris, de la pagination, etc. Ce NuGet pourra éventuellement être personnalisé.

1. utiliser les 'tooltips' de Twitter (disponible dans les NuGet).

1. implémenter une manière non vue au cours est un plus (exemple: modèle [MVVM](https://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-vue_mod%C3%A8le)).

1. implémenter une 'WebAPI'. Par exemple: on donne le code d'un pays et on reçoit le nom de ce pays.

1. créer au moins deux formulaire et une table (grid). Dans les formulaires, il faudra faire apparaître tous les types de données (chaîne de caractères, nombre, date, heure, booléen...). Pour les booléens, il ne faut pas utiliser de case à cocher (mais plutôt des interrupteurs).

1. utiliser les '[Google Charts](https://developers.google.com/chart/)'.

1. utiliser des listes déroulantes dépendantes. Par exemple la première liste reprend des marques de voitures et lorsque la marque est sélectionnée, la deuxième reprend les modèles de la marque.

1. paramétrer le fichier de configuration principal et savoir l'expliquer.

1. charger sur le site et télécharger un fichier (sans avoir à le traiter).

1. publier le site sur IIS. Ce dernier devra pouvoir être configuré.

1. pouvoir expliquer les flux de données et débugger après le plantage réalisé par le prof.

1. prendre en compte les points suivants: utilisation des sessions, création de tests unitaires (au moins 1), navigation entre les pages.

## Remarques:

1. Bien comprendre tout ce qu'on fait.

1. Idéalement, on utilise un base de données. Si cela est trop compliqué, on peut à défaut utiliser d'autres structures de données comme les listes.

1. Le code HTML doit être correct.

1. Le design a son importance (on peut utiliser une version personnalisée de Bootstrap).

1. Il ne faut pas réinventer la roue. Si un outil existe, il faut pouvoir utiliser au maximum ce qui existe déjà.

1. Tout ce qui aura été réussi en première session ne devra plus être fait en seconde session.