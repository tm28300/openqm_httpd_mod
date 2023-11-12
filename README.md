# Description

openqm_hhpd_mod est un module Apache 2.4 httpd permettant d'exécuter une routine OpenQM pour traiter une requête. La routine reçoit les informations de la requête et peut retourner un code erreur, qui va générer une page d'erreur standard ou bien retourner l'en-tête http et la réponse. La réponse peut être d'un format quelconque comme défini dans l'en-tête Content-Type.

# Installation

Le module doit être compilé et nécessite les dépendances suivantes :
- gcc
- apache2-dev
- libpcre3-dev
- makefile

Ensuite il faut exécuter la commande **make** puis **make install**.

# Utilisation

Dans le fichier de configuration du vhost Apache httpd il faut ajouter la directive OpenQMLocalAccount.

La routine appelée doit avoir 18 paramètres. Les 15 premiers paramètres sont en entrée :
- auth_type : Le type d'authentification de la requête.
- document_root : Le document_root du virtual host.
- gateway_interface : Non défini pour l'instant.
- hostname : Le hostname de la requête.
- headers_in : Les en-tête de la requête sous forme d'un tableau dynamique constitué de deux attributs liés en multi-valeur. Le premier attribut contient le nom de la variable d'en-tête et le second la valeur.
- path_info : Le path_info de la requête. C'est à dire la partie de l'uri qui n'a pas été utilisée pour trouver le fichier exécuté.
- path_translated : Chemin du fichier sur le serveur correspondant à la requête.
- query_string : Les paramètres de la requête sous la forme d'une query_string comme pour une requête get. Si s'agit d'une requête post les paramètres sont concaténés avec les séparateurs "=" et "&" pour former une chaîne comme pour une requête get.
- remote_info : Adresse IP et port du client séparés par ":".
- remote_user : Utilisateur identifié selon la configuration du virtual host.
- request_method : Méthode d'appel (GET, POST, PUT, PATH ou DELETE).
- request_uri : URI pour accéder à la page.
- script_filename : Nom du fichier script indiqué dans l'URI avec son chemin absolu.
- script_name : Nom du fichier script indiqué dans l'URI sans chemin.
- server_info : Toutes les variables d'environnement du serveur httpd sous forme d'un tableau dynamique constitué de deux attributs liés en multi-valeur. Le premier attribut contient le nom de la variable d'en-tête et le second la valeur.

Les 3 dernier paramètres sont utilisés pour le retour. En accord avec la librairie client OpenQM ces variables sont initialisés lors de l'appel et la routine ne doit pas affecter une chaîne plus longue que le tampon initialisé. Ces variables sont :

# Limitation

Je n'ai pas trouvé comment retourner un message d'erreur personnalisé. Afin de passer outre cette limitation j'ai développé un micro serveur httpd avec .

Le serveur Apache httpd et le serveur OpenQM doivent être installés sur le même serveur et l'utilisateur d'exécution du httpd doit pouvoir se connecter à OpenQM via la librairie client.
