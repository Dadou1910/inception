# Inception

## 📁 Description

`Inception` est un projet du cursus 42 qui initie à la **virtualisation** et à l'utilisation de **Docker** pour déployer une infrastructure de services sur une machine virtuelle.  
Il vise à comprendre la création de conteneurs, la gestion de volumes, de réseaux Docker et la configuration de services comme Nginx, WordPress, MariaDB, Redis, etc.

> Ce projet est développé pour fonctionner **localement sur la machine de l'étudiant**, avec des fichiers de configuration personnalisés.

---

## 🔧 Installation

> ⚠️ Il **n'est pas possible de cloner ce projet avec un simple `git clone` et de l'exécuter tel quel**.

Ce projet contient des configurations liées à l'utilisateur local, notamment des **chemins root** et des privilèges `sudo` propres à la machine de développement. Pour l'utiliser, il faut :

- Adapter les chemins dans les fichiers Docker / volumes
- Modifier les permissions et propriétés de certains dossiers avec `sudo`
- S'assurer que Docker et Docker Compose sont installés sur votre machine

---

## 📃 Documentation

Toutes les explications du projet sont incluses **directement dans les fichiers**, sous forme de **commentaires** dans :

- Les `Dockerfile`
- Les `docker-compose.yml`
- Les scripts d'installation et de configuration

Chaque service est documenté ligne par ligne pour aider à la compréhension de l'architecture globale.

---

## 🌐 Services généralement inclus

- Nginx
- WordPress
- MariaDB
- Redis (si bonus)
- Adminer ou phpMyAdmin (si bonus)
- FTP ou autres services (si bonus)

---

## 💼 Utilisation (après configuration)

```bash
docker-compose -f srcs/docker-compose.yml up --build
```
Vous accédez ensuite au site WordPress en local via :

https://localhost

👤 Auteur

Projet réalisé par :

    👤 @Dadou1910

📄 Licence

Projet réalisé dans le cadre du cursus 42.
Ce projet contient des configurations locales et ne peut être utilisé tel quel sans adaptation.
