# **Monumental**

  

**Monumental** est une application iOS permettant de découvrir les monuments historiques en France grâce à la géolocalisation et une carte interactive. Elle offre une expérience culturelle enrichissante en mettant à disposition des informations détaillées sur les monuments à proximité.

  

## **📝 Description**

  

L’application utilise des technologies modernes pour offrir une navigation fluide et des fonctionnalités optimales :

  

• Géolocalisation précise pour afficher les monuments proches.

• Cartographie interactive pour explorer facilement les lieux historiques.

• Favoris pour sauvegarder les monuments préférés.

• Intégration de données en temps réel grâce à des API.

  

## **📜 Fonctionnalités principales**

  

**1\. Géolocalisation des monuments**

- Utilisation de **CoreLocation** pour déterminer la position de l’utilisateur.

- Affichage des monuments environnants grâce à **MapKit**.

  

**2\. Consultation des détails**

- Informations détaillées sur chaque monument via un panneau interactif (**FloatingPanel**).

- Permet de consulter les détails sans obstruer la carte.

  

**3\. Sauvegarde des favoris**

- Stockage local des monuments favoris grâce à **CoreData**.

- Accès rapide aux lieux sauvegardés pour une consultation ultérieure.

  

**4\. Performances et optimisation**

- Surveillance des performances via **Firebase Performance SDK**.

- Chargement rapide des données grâce à **Alamofire** et **CoreData**.

  

## **🎨 Interface utilisateur**

- **Responsive Design** : Interface adaptée à toutes les tailles d’écran.

- **Carte interactive** : Navigation fluide et intuitive.

- **Effets modernes** : Panneaux flottants et animations fluides pour une meilleure expérience.

  

## **🛠️ Architecture technique**

1\. **Architecture MVC (Modèle-Vue-Contrôleur)** :

- Séparation claire des responsabilités pour une meilleure maintenance.

- Intégration de **ViewDelegate** pour renforcer l’interaction entre les vues et les contrôleurs.

2\. **Gestion des données** :

- **API Explorer** pour récupérer les informations des monuments.

- Persistance locale avec **CoreData** pour accéder aux données hors ligne.

3\. **Localisation et affichage** :

- **CoreLocation** pour la position de l’utilisateur.

- **MapKit** pour afficher les monuments sur une carte.

4\. **Intégration continue et surveillance** :

- **Bitrise** pour automatiser les tests, la construction et le déploiement.

- **Firebase Performance SDK** pour surveiller et optimiser les performances.

  

## **🚀 Installation**

1\. Clonez le dépôt GitHub :

  
```bash
git clone https://github.com/GianiGBS/Monumental.git

cd Monumental
```
 
2\. Ouvrez le projet dans Xcode.

3\. Configurez les clés API nécessaires pour l’intégration avec les services tiers (API Explorer, OpenWeather, etc.).

4\. Lancez l’application sur un simulateur ou un appareil physique compatible.

  

## **✅ Tests**

- Automatisation des tests avec **Bitrise** pour garantir la qualité du code.

- Tests unitaires pour vérifier les fonctionnalités principales.

- Surveillance des performances et optimisation continue.

  

## **🎁 Points forts et bonus**

1\. **UI moderne et intuitive** :

- Navigation interactive avec **FloatingPanel**.

- Consultation sans interrompre la vue principale.

2\. **Performances optimisées** :

- Chargements rapides grâce à la gestion des données locales et des API.

3\. **Personnalisation** :

- Possibilité de sauvegarder et de consulter des favoris.

  

## **🤝 Contribution**

  

Les contributions sont les bienvenues ! Si vous souhaitez signaler un problème ou proposer des améliorations, ouvrez une issue ou une pull request sur ce dépôt.

  

## **📜 Licence**

  

Ce projet est sous licence MIT. Consultez le fichier LICENSE pour plus d’informations.

  

## **🎥 Démonstration**

  

Avec **Monumental**, explorez les monuments historiques près de chez vous ou lors de vos voyages. L’application vous permet de :

  

1\. Découvrir les monuments autour de votre position actuelle.

2\. Enregistrer vos lieux préférés pour y revenir facilement.

3\. Naviguer de manière fluide et intuitive grâce à une interface moderne.
