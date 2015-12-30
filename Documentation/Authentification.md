# Authentification

Tout d'abord, nous allons définir le chemin de login. Pour cela, nous éditons le fichier `~\Web.config` et ajouter ceci:

````
<configuration>
  <!-- ... -->
  <system.web>
    <!-- ... -->
    <authentication mode="Forms">
      <forms loginUrl="~/Home/Login" timeout="2880" />
    </authentication>
  </system.web>
  <!-- ... -->
</configuration>
````

Ensutie, on crée la classe `~\Models\LoginFormModel.cs`. Celle-ci sera utilisée pour recevoir les données du formulaire.

Dans le contrôleur `~\Controllers\HomeController.cs`, nous définirons les méthodes `Login()` et `Logout()` qui serviront à s'identifier et se déconnecter. Les données d'authentification seront sauvegardées dans un cookie crypté. Pour générer ce cookie, nous auront besoin de créer un ticket (`FormsAuthenticationTicket`). Pour ce faire, nous créerons le "*helper*" `~\Helpers\LoginHelper.cs` avec une méthode `CreateAuthenticationTicket()`. Pour décrypter notre cookie, nous créons la méthode `Application_AuthenticateRequest()` dans `~\Global.asax.cs`.

`~\Views\Shared\_Layout.cshtml` sera modifié pour ajouter un lien vers la page de connexion (si on n'est pas connecté) et la page de déconnexion (si on est connecté). Nous créerons la vue `~\Views\Home\Login.cs` qui sera le formulaire d'identification.

Dans les vues, nous pouvons tester si nous sommes identifié ou pas grâce à l'attribut `User.Identity.IsAuthenticated` et si nous faisons partie d'un groupe ou pas grâce à la méthode `User.IsInRole()`.

Dans les contrôleurs, nous pouvons restreindre les accès des méthodes aux seules personnes identifiées grâce à l'attribut `[Authorize]` et aux personnes faisant partie d'un groupe grâce à l'attribut `[Authorize(Roles="...")]`.
