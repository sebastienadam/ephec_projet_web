# Personnalisation des classes générées par *Entity Framework*

Si nous personnalisons une classe générée par *Entity Framework*, tout sera perdu en cas de rafraichissement des classes. Nous pouvons contourner le problème en utilisant une "métadatatype".

Pour illustrer la technique, nous allons personnaliser ici l'entité `Reception`. Les classes générées par *Entity Framework* sont partielles. Ainsi, nous pouvons les redéfinir ailleurs avec le modifieur `partiel`.

Ainsi, Nous allons créer le fichier `~\Models\ReceptionModel.cs`. Dans ce fichier, nous allons créer une classe partielle `Reception` dans le même espace de nom que celle que nous voulons modifier. Nous créons notre classe qui servira de modèle avec les spécificités désirées (noms à afficher, paramètres requis, formatage des données...). Dans notre exemple, nous créons la classe `ReceptionModel` dans l'espace de nom `Models`.

Pour que la classe de *Entity Framework* reflète les spécifications de notre modèle, nous allons faire précéder la classe partielle `Reception` que nous avons créé par `[MetadataType(typeof(Models.ReceptionModel))]`. Ainsi, lorsque nous utiliserons la classe `Reception`, elle respectera les spécifications de `ReceptionModel`.