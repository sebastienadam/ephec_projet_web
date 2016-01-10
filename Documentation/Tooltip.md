# Tooltip

Les *tooltips* sont intégrés à jQuery UI. Il ne faut donc rien y ajouter.

La personnalisation du style est faite dans le fichier `~\Content\jqueryui.custom.css`. Il s'agit d'un copier-collé de l'[exemple du site jQuery UI](https://jqueryui.com/tooltip/#custom-style). Cette feuille de style a été ajoutée au "*bundle*" de styles `"~/Content/JQueryUI/css"`.

L'utilisation des *tooltips* ont été utilisé dans le formulaire de création d'une réception. Le texte et la position ont été personnalisés. Exemple:

````
$('.adddish').tooltip({
    content: "Cliquez ici pour ajouter le plat sélectionné à la liste.",
    items: "button",
    position: { my: "right bottom-24", at: "right up" }
});
````

Les *tooltips* ont également été utilisés pour montrer l'affiche des réceptions dans la liste des réceptions. Un attribut `data-poster` est ajouté à chaque ligne correspondant à une réception pour laquelle une image a été chargée. Ensuite, le code suivant a été utilisé pour générer le *tooltip*.

````
$('tr[data-poster]').tooltip({
    items: "tr",
    content: function () {
        var path = $(this).attr("data-poster");
        return '<img src=' + path + ' alt="Affiche de la réception" />';
    }
});
````