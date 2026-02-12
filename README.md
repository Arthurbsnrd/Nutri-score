☘️ Nutri-Eco Intelligence Dashboard
Nutri-Eco Intelligence Dashboard est une plateforme d'analyse multidimensionnelle conçue pour transformer la complexité des données alimentaires en insights actionnables. L'application interroge en temps réel l'API mondiale d'Open Food Facts pour croiser santé, écologie et transformation industrielle.

🚀 Vision du Projet
L'objectif est de dépasser l'analyse simple pour proposer une vision à 360° du produit :

Qualité Nutritionnelle (Nutri-Score)

Impact Environnemental (Eco-Score)

Niveau de Transformation (Score NOVA)

📊 Fonctionnalités Avancées
Analyse Bivariée (Heatmap) : Une matrice de corrélation dynamique croisant le Nutri-Score et l'Eco-Score pour identifier les produits "Sains et Durables" versus les paradoxes alimentaires.

Monitoring de l'Ultra-Transformation : Calcul en temps réel du taux de produits NOVA 4 (aliments ultra-transformés) sur l'échantillon analysé.

Indicateurs Clés (KPIs) :

Volume total de données disponibles en base mondiale pour la requête.

Détermination automatique des scores dominants (Mode statistique).

Taux de transformation industrielle global.

Explorateur de Données : Tableau interactif détaillé permettant de vérifier chaque référence individuelle.

🛠️ Stack Technique
Framework : Shiny (R) avec thème bslib pour une interface réactive.

Data Pipeline :

httr2 : Requêtage asynchrone de l'API REST Open Food Facts v2.

jsonlite : Parsing et normalisation des flux JSON.

tidyverse & dplyr : Pipeline de nettoyage (Data Wrangling) et calculs statistiques.

ggplot2 : Visualisations bivariées et distribution de fréquences.

📦 Installation et Lancement
R
# 1. Installation des dépendances
install.packages(c("shiny", "httr2", "jsonlite", "tidyverse", "bslib", "DT"))

# 2. Lancement
# Exécuter le fichier app.R dans RStudio
shiny::runApp()
📈 Perspectives IA & Data Science
NLP (Natural Language Processing) : Analyse automatisée des listes d'ingrédients pour détecter les additifs controversés.

Machine Learning : Implémentation de modèles d'imputation pour prédire les scores manquants à partir des profils nutritionnels.

Clustering : Segmentation des produits par profil de nutriments via K-means.
