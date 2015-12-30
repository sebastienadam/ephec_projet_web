# Gestion des erreurs

Dans un premier temps, nous allons créer la méthode `Application_Error()` dans `~\Global.asax.cs`. Cette dernière va intercepter toutes les erreurs. En cas d'erreur, la page appelée par défaut est `~/Error/Index`. S'il s'agit d'une erreur HTTP 404 (page non trouvée), c'est la page `~/Error/NotFound` qui est appelée. En modifiant cette méthode, nous pourrons appeler d'autres pages pour des erreurs spécifiques.

La méthode `Application_Error()` va également créer un fihcier journal dans `~\App_Data` grâce à la classe `~\Helpers\ExceptionUtility.cs`.

Pour afficher les pages d'erreur, le contrôleur `~\Controllers\ErrorController.cs` est utilisé. Il possède les méthodes `Index()` et `NotFound()` avec les vues correspondantes. Les pages affichées ne donne aucun détail quant à l'erreur survenue. Il faut aller voir dans le fichier journal pour avoir les détails.
