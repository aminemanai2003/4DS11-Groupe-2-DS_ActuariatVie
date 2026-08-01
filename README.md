# Mortalité, longévité et tarification d’une rente temporaire

[![R](https://img.shields.io/badge/R-StMoMo-276DC3?logo=r&logoColor=white)](https://cran.r-project.org/)
[![Données](https://img.shields.io/badge/donn%C3%A9es-Human%20Mortality%20Database-17324D)](https://www.mortality.org/)
[![Rapport](https://img.shields.io/badge/rapport-PDF-0F766E)](Rapport/Rapport_Projet_Actuariat_Vie_Sujet3_Groupe-2-DS.pdf)

Étude actuarielle d’une rente viagère temporaire souscrite en 2015 par une cohorte née en 1955 en Angleterre et au Pays de Galles. Le projet relie projection stochastique de la mortalité, probabilités de survie et valeur actuelle probable (VAP), puis mesure la sensibilité du tarif au modèle, au taux d’actualisation et à la composition du portefeuille.

## Question actuarielle

Le portefeuille considé est composé de 60 % de femmes et de 40 % d’hommes. Les assurés ont 60 ans au début du contrat, dont les prestations peuvent être versées entre 2015 et 2045.

L’analyse cherche à répondre à quatre questions :

- comment projeter la mortalité de la cohorte jusqu’à 90 ans ;
- quel modèle produit les projections hors échantillon les plus robustes ;
- comment convertir ces projections en valeur actuelle probable d’une rente ;
- comment le taux d’actualisation et la composition femmes-hommes modifient-ils le tarif unisexe ?

## Cadre mathématique

Les décès observés sont modélisés par une loi de Poisson conditionnelle à l’exposition :

$$
D_{x,t} \sim \mathcal{P}\!\left(E_{x,t}\mu_{x,t}\right),
\qquad
\widehat{\mu}_{x,t}=\frac{D_{x,t}}{E_{x,t}}.
$$

Le modèle de référence Lee–Carter décompose la surface de mortalité selon :

$$
\log \mu_{x,t}=a_x+b_x k_t+\varepsilon_{x,t}.
$$

Pour une rente temporaire annuelle à termes anticipés, la valeur actuelle probable est :

$$
\mathrm{VAP}(i)=R\sum_{k=0}^{n-1}(1+i)^{-k}\,{}_{k}p_x.
$$

## Méthode

1. Extraction des décès, expositions et taux de mortalité de la [Human Mortality Database](https://www.mortality.org/) pour l’Angleterre et le Pays de Galles (`GBRTENW`).
2. Estimation des taux par maximum de vraisemblance et construction d’intervalles de confiance.
3. Suivi longitudinal de la cohorte 1955 avec `extractCohort`.
4. Ajustement et projection de trois modèles `StMoMo` : Lee–Carter, Age–Period–Cohort et Cairns–Blake–Dowd.
5. Validation temporelle : apprentissage sur 1960–2015 et évaluation sur 2016–2022 avec la RMSE et la MAE des log-taux.
6. Conversion des taux centraux en probabilités annuelles de décès, puis calcul de la VAP.
7. Analyses de sensibilité au taux d’actualisation et à la composition du portefeuille.

## Enseignements principaux

- La VAP féminine est supérieure à la VAP masculine dans cette application, en raison d’une mortalité projetée plus faible et d’une durée attendue de versement plus longue.
- Une hausse du taux d’actualisation diminue la VAP, avec un effet plus marqué pour les paiements éloignés.
- Lee–Carter constitue une référence interprétable, tandis qu’APC permet de tester un effet de cohorte et CBD cible les âges adultes et élevés.
- Une prime unisexe issue de la population totale peut différer du coût du portefeuille réel ; la pondération 60/40 rend ce transfert explicite.
- Le choix du modèle doit reposer sur la validation temporelle, la stabilité des projections et l’interprétation actuarielle, et non uniquement sur l’ajustement en échantillon.

## Livrables

- [Rapport actuariel complet — PDF](Rapport/Rapport_Projet_Actuariat_Vie_Sujet3_Groupe-2-DS.pdf)
- [Rapport interactif — HTML](Rapport/Rapport_Projet_Actuariat_Vie_Sujet3_Groupe-2-DS.html)
- [Code source reproductible — R Markdown](Rapport/Rapport_Projet_Actuariat_Vie_Sujet3_Groupe-2-DS.Rmd)
- [Présentation de synthèse — PDF](Presentation/Presentation_ActuariatVie_Sujet3_Groupe-2-DS.pdf)
- [Tableau de bord statique](Site/index.html)

## Structure du dépôt

```text
.
├── Rapport/       # analyse, code R Markdown, bibliographie et sorties
├── Presentation/  # présentation LaTeX et graphiques
├── Site/          # tableau de bord de synthèse
├── machine.html   # calculateur interactif
└── README.md
```

## Reproduire l’analyse

### Prérequis

- R 4.5 ou version compatible ;
- packages `demography`, `StMoMo`, `rmarkdown` et leurs dépendances ;
- Pandoc/Quarto ou RStudio pour générer les documents ;
- compte autorisé sur la Human Mortality Database.

Les identifiants HMD ne sont jamais enregistrés dans le dépôt. Ils doivent être fournis par variables d’environnement :

```powershell
$env:HMD_USERNAME = "votre_identifiant"
$env:HMD_PASSWORD = "votre_mot_de_passe"
Set-Location Rapport
.\render_rapport.ps1
```

Le script de rendu contient les chemins locaux de l’environnement utilisé pour produire les livrables ; adaptez les chemins vers R et Pandoc si votre installation est différente.

## Limites

- Les résultats portent sur une cohorte et une population nationales précises ; ils ne sont pas directement transposables à un autre portefeuille.
- Les trajectoires futures prolongent l’information historique disponible et restent sensibles aux ruptures de tendance.
- Le portefeuille est décrit uniquement par le sexe et l’année de naissance ; aucune sélection médicale, hétérogénéité socioéconomique ou dynamique de sortie n’est modélisée.
- Le taux d’actualisation est traité par scénarios déterministes et non par un modèle actif-passif complet.
- La comparaison unisexe illustre un transfert actuariel interne ; elle ne constitue pas une analyse juridique ou commerciale du produit.

## Auteurs

Projet réalisé par Amine Manai, Maha Aloui, Nassir Bouzaiene et Yasmine Attyaoui. La répartition détaillée des travaux et les références scientifiques figurent dans le rapport.
