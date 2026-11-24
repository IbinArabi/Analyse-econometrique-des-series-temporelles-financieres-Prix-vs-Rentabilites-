Dans le cadre de mon projet académique, j'ai étudié les propriétés statistiques d'actifs financiers (Indices, Actions, Obligations, Forex, Crypto) sur la période 2020-2025, couvrant plusieurs régimes de marché (COVID-19, resserrement monétaire).

🔍 Ce que j'ai analysé :

Données & Transformation : Téléchargement et traitement de 10 actifs via Yahoo Finance, avec passage des prix aux rentabilités logarithmiques.

Tests de Stationnarité : Étude des ACF/PACF et validation par les tests formels ADF (Augmented Dickey-Fuller) et KPSS. Sans surprise, les prix sont non-stationnaires, mais les rentabilités le sont.

Mise en évidence des faits stylisés : Confirmation de la non-normalité des rendements (queues épaisses, kurtosis > 3) et de l'agrégation de la volatilité.

Simulation ARMA : Modélisation de 10 processus théoriques (AR, MA, ARMA) sous R pour confronter les signatures théoriques (ACF/PACF) aux données empiriques.

💡 Le principal enseignement :
Si les rentabilités se comportent comme un bruit blanc (autocorrélation quasi nulle), la modélisation par de simples processus ARMA trouve ses limites face aux faits stylisés des marchés financiers (hétéroscédasticité, queues épaisses). Cela ouvre la voie à des modèles plus avancés comme les processus GARCH pour la volatilité.

Outils : R (quantmod) | Python
