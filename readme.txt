Projet : Prédiction de l’État d’un crime

Objectif du projet
L’objectif est de prédire l’État américain où un crime a été commis à partir des caractéristiques des victimes et des circonstances de leur disparition.

* Variable cible : `State` (WA, UT, CO, FL, OR, ID, …)
* Variables explicatives :

  * `AgeGroup` : catégorie d’âge de la victime
  * `Month` : mois de la disparition
  * `Keywords` : indicateurs extraits de Notes ("school", "sorority", "abducted", "home", etc.)

Description du dataset

* 20 victimes documentées de crimes (principalement Ted Bundy).
* Variables principales :

  | Variable | Type      | Description                     |
  | -------- | --------- | ------------------------------- |
  | Victim   | Texte     | Nom de la victime               |
  | Age      | Numérique | Âge au moment de la disparition |
  | Date     | Date      | Date de la disparition          |
  | Location | Texte     | Ville + État                    |
  | Notes    | Texte     | Contexte de la disparition      |

Prétraitement :

* Extraction de `State` depuis `Location`
* Conversion de `Age` en catégories (`Child`, `Teen`, `YoungAdult`, `Adult`)
* Extraction du `Month` à partir de `Date`
* Extraction de mots-clés dans `Notes` pour créer des variables qualitatives

Interprétation de l’arbre CHAID
-Racine : Variable “Month”

* Le modèle a choisi Month comme premier point de division, indiquant que le mois de disparition est lié à l’État du crime.
* Le mois de disparition est un facteur discriminant.

- Branche 1 → Node 2 (n = 16)

* Mois : Jan, Feb, Mar, Apr, May, Jul, Oct, Nov, None
* Distribution : CO, FL, ID, OR, UT, WA
* Interprétation : ces mois ne permettent pas de prédire un État dominant, les victimes sont réparties.

- Branche 2 → Node 3 (n = 5)

* Mois : Jun, Aug, Sep, Dec
* Distribution concentrée sur UT, WA
* Interprétation : ces mois sont fortement associés à Utah et Washington.

Étapes suivantes

* Tester si d’autres variables (`school`, `sorority`, `abducted`) renforcent la prédiction ou interagissent avec le mois.
* L’arbre CHAID montre déjà l’ordre d’importance implicite des variables : racine → plus discriminante, nœuds suivants → autres variables significatives.
## ⚠️ Limitations & Future Work

### Limitations
- **Taille du dataset** : le projet repose sur ~20 victimes documentées. Ce volume est trop faible pour construire un modèle prédictif robuste ; l’arbre CHAID est donc surtout exploratoire.
- **Biais historique** : les données concernent principalement Ted Bundy. Elles ne sont pas représentatives de l’ensemble des homicides aux États-Unis.
- **Variables simplifiées** : les mots-clés extraits des notes sont définis manuellement et en nombre limité. Cela réduit la richesse des informations textuelles.
- **Sur-apprentissage possible** : avec un petit échantillon et des paramètres permissifs (`minbucket=1`, `minsplit=1`), l’arbre peut sur-apprendre aux données existantes.

### Future Work
- **Enrichir le dataset** : intégrer davantage de cas d’homicides documentés pour améliorer la robustesse statistique.
- **Text mining avancé** : utiliser des techniques de NLP (`tidytext`, `tm`) pour extraire automatiquement des mots-clés et thèmes des notes.
- **Validation croisée** : appliquer des méthodes comme leave-one-out ou k-fold cross-validation pour tester la stabilité du modèle.
- **Visualisations supplémentaires** : créer des timelines, cartes géographiques et distributions d’âge pour compléter l’arbre CHAID.
- **Comparaison de modèles** : tester d’autres algorithmes (CART, Random Forest, Logistic Regression) pour comparer les performances.
