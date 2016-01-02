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