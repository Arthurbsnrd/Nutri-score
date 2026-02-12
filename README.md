Green Score Live Tracker
Green Score Live Tracker est une application web interactive développée avec R et Shiny. Elle permet d'analyser en temps réel l'impact nutritionnel et environnemental des produits alimentaires à travers le monde en interrogeant directement l'API d'Open Food Facts.

Fonctionnalités
Recherche en temps réel : Accès direct à la base de données mondiale d'Open Food Facts (v2).

Indicateurs Clés (KPIs) :

Nombre total de produits référencés en base pour la recherche.

Calcul du Nutri-Score majoritaire sur les résultats.

Calcul de l'Eco-Score majoritaire sur les résultats.

Visualisations Dynamiques :

Graphique de répartition des grades Nutri-Score (Santé).

Graphique de répartition des grades Eco-Score (Environnement).

Explorateur de Données : Tableau détaillé des produits incluant le nom, la marque et les scores respectifs.

Technologies utilisées
Langage : R

Interface : Shiny avec le thème bslib (Bootswatch "Minty").

API : Open Food Facts API v2.

Packages R principaux :

httr2 : Pour les requêtes HTTP vers l'API.

jsonlite : Pour le traitement des données au format JSON.

tidyverse (ggplot2, dplyr) : Pour la manipulation et la visualisation des données.

DT : Pour les tableaux interactifs.

Installation
Pour lancer l'application localement, assurez-vous d'avoir R installé, puis exécutez les commandes suivantes dans votre console R :

R
# Installation des packages nécessaires
install.packages(c("shiny", "httr2", "jsonlite", "tidyverse", "bslib", "DT"))

# Lancer l'application
# Copiez le code du fichier app.R et lancez :
shiny::runApp()
Utilisation
Entrez un mot-clé dans la barre latérale (ex: "Oreo", "Biscuits", "Jus d'orange").

Cliquez sur le bouton "Lancer la recherche".

L'application interroge l'API, récupère le volume total de produits en base et analyse les 100 résultats les plus pertinents pour générer les graphiques de tendance.
