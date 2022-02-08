# Projet-BI

Ce projet consistait à mettre en place un datawarehouse pour une enseigne de prêt-à-porter installée dans le Nord.
L'objectif de ce dernier est de stocker l'ensemble des informations clients afin de mieux connaître ces derniers.
Pour ce faire, nous avons mis en place les flux d'alimentation du DWH avec l'outil ELT Oracle Data Integrator et créé un tableau de bord avec l'outil POWER BI

## Conceptualisation de l'intégration des données au sein du DWH

![alt text](https://github.com/cedric-ebia/Projet-BI/blob/main/Test%20concept.png?raw=true)


```
select * from Adresse;
```
