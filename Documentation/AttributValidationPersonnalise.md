#Attribut de validation personnalisé

J'ai défini un attribut de validation personnalisé pour vérifier que la date de clôture des inscription est bien inférieure à la date de la réception. La documentation est vraiment très succinte sur le sujet.

J'ai créé le fichier `~\Attribute\DateTimeLessThanOrEqualAttribute.cs` contenant la classe `DateTimeLessThanOrEqualAttribute` et qui étend `CompareAttribute`. La récupération de la valeur de l'autre propriété a été un peu laboriause (attention).

L'attribut a été utilisé dans `~\Models\NewReceptionModel.cs`:

````
//(...)
    public DateTime Date { get; set; }
//(...)
    [DateTimeLessThanOrEqual("Date")]
    public DateTime BookingClosingDate { get; set; }
//(...)
````