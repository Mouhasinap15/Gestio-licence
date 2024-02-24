#!/bin/bash

# Fonction pour bloquer un utilisateur
function bloque {
	sudo usermod --lock $1
}

# Fonction pour déterminer le niveau en fonction de la classe
function niveau {
    case $1 in
        l12i|l1mpi) niv="licence1";;
        l22i|l2mi) niv="licence2";;
        l32i|l3in) niv="licence3";;
    esac
    
    echo $niv
}

# Fonction pour afficher les informations d'un utilisateur
function affichage {
    echo "Nom: $1"
    echo "Prénom: $2"
    echo "Login: $3"
    echo "Classe: $4"
    echo "Niveau: $5"
    echo "Date de création: " $6
    echo "Date d'expiration: " $7
}

# Fonction pour déterminer la classe en fonction de l'entrée de l'utilisateur
function class {
    while true; do
        read -p "Donner votre classe (1-6): " r
        if [[ $r -ge 1 && $r -le 6 ]]; then
            break
        fi
    done

    case $r in
        1) cl="l12i";;
        2) cl="l22i";;
        3) cl="l32i";;
        4) cl="l1mpi";;
        5) cl="l2mi";;
        6) cl="l3in";;
    esac

    echo $cl
}

# Fonction pour débloquer un utilisateur
function debloque {
	sudo usermod --unlock $1
}

# Fonction pour créer un utilisateur avec un ensemble de paramètres
function create_user {
    sudo useradd -m -s /bin/bash $1

    echo "Utilisateur '$1' créé avec succès."

    # Calculer la date d'expiration (18 mois plus tard)
    expiration_date=$(date -d "18 months" +"%Y-%m-%d")
    sudo chage -E $expiration_date $1

    echo "Date d'expiration définie à $expiration_date pour l'utilisateur '$1'."
    new_home="/home/licence/$2/$3/$1"
    sudo mkdir $new_home
    sudo chown $1:$1 /home/licence/$2/$3/$1
    sudo chmod 770 $new_home
    
    sudo usermod -d $new_home $1
    echo "Répertoire personnel déplacé vers $new_home."
}

# Fonction pour ajouter un utilisateur à un groupe en fonction de la classe
function groupe {
	case $1 in
		l12i) sudo usermod -aG licence,l2i,l1,l12i $2 ;;
		l22i) sudo usermod -aG licence,l2i,l2,l22i $2;;
		l32i) sudo usermod -aG licence,l2i,l3,l32i $2;;
		l1mpi) sudo usermod -aG licence,lin,l1,l1mpi $2;;
		l2mi) sudo usermod -aG licence,lin,l2,l2mi $2;;
		l3in) sudo usermod -aG licence,lin,l3,l3in $2;;
    	esac
}

# Fonction pour créer des liens symboliques
function liens {
	sudo ln -s /home/partages/licence /home/licence/$2/$1/$3/licence
	case $1 in
		l12i) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/l1
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l12i /home/licence/$2/$1/$3/l12i
			;;
		l22i) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/l2
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l22i /home/licence/$2/$1/$3/l22i
			;;
		l32i) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/l3
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l32i /home/licence/$2/$1/$3/l32i
			;;
		l1mpi) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/l1
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l1mpi /home/licence/$2/$1/$3/l1mpi
			;;
		l2mi) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/l2
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l2mi /home/licence/$2/$1/$3/l2mi
			;;
		l3in) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/l3
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l3in /home/licence/$2/$1/$3/l3in
			;;  
	esac
}

# Fonction pour modifier les informations d'un utilisateur
function modifier {
    local login="$1"
    cd ~/.gestlic
    # Vérifier si le fichier compte.txt existe
    if [ ! -f "compte.txt" ]; then
        echo "Erreur: Le fichier compte.txt n'existe pas."
        return 1
    fi

    # Rechercher le login dans le fichier compte.txt
    local ligne=$(grep "^.*:${login}:" compte.txt)

    if [ -z "$ligne" ]; then
        echo "Le login $login n'a pas été trouvé dans le fichier compte.txt."
        return 1
    fi

    # Extraire le nom et le prénom actuels
    local nom_actuel=$(echo "$ligne" | cut -d ":" -f 1)
    local prenom_actuel=$(echo "$ligne" | cut -d ":" -f 2)

    # Demander à l'utilisateur de fournir le nouveau nom
    read -p "Entrez le nouveau nom [$nom_actuel] : " nouveau_nom
    nouveau_nom=${nouveau_nom:-$nom_actuel}

    # Demander à l'utilisateur de fournir le nouveau prénom
    read -p "Entrez le nouveau prénom [$prenom_actuel] : " nouveau_prenom
    nouveau_prenom=${nouveau_prenom:-$prenom_actuel}

    # Construire la nouvelle ligne avec le nom et le prénom modifiés
    local nouvelle_ligne="${nouveau_nom}:${nouveau_prenom}:$(echo "$ligne" | cut -d ":" -f 3-)"

    # Remplacer la ligne dans le fichier compte.txt
    sed -i "s|${ligne}|${nouvelle_ligne}|" compte.txt

    echo "Le nom et prénom pour le login $login ont été modifiés avec succès."
}

# Fonction pour vérifier la création des répertoires d'architecture
function archi {
	i=0
	if [ -f "/home/licence/licence1/l12i" ] ; then
		i=i+1
	fi
	if [ -f "/home/licence/licence1/l1mpi" ] ; then
		i=i+1
	fi
	if [ -f "/home/licence/licence2/l22i" ] ; then
		i=i+1
	fi
	if [ -f "/home/licence/licence3/l32i" ] ; then
		i=i+1
	fi
	if [ -f "/home/licence/licence2/l2mi" ] ; then
		i=i+1
	fi
	if [ -f "/home/licence/licence3/l3in" ] ; then
		i=i+1
	fi
	if [ i=6 ] ; then
		echo "Tous les répertoires de l'architecture proposée sont créées."
	else
		echo "Tous les répertoires de l'architecture proposée ne sont pas créées."
	fi
}

# Fonction pour vérifier la création des répertoires de partages
function partages {
	i=0
	if [ -f "/home/partages/licence" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l1" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l2" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l3" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l2i" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/lin" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l3in" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l2mi" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l1mpi" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l22i" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l12i" ] ; then
		i=i+1
	fi
	if [ -f "/home/partages/l32i" ] ; then
		i=i+1
	fi
	if [ i=12 ] ; then
		echo "Tous les répertoires de partages sont créées."
	else
		echo "Tous les répertoires de partages ne sont pas créées."
	fi
}

# Fonction pour vérifier la création du fichier caché et des fichiers utiles
function cache {
	i=0
	if [ -f "~/.gestlic/compte.txt" ] ; then
		i=i+1
	fi
	if [ i=1 ] ; then
		echo "Le fichier caché et les fichiers utile au bon fonctionnement de gestlic sont créées"
	else
		echo "Le fichier caché et les fichiers utile au bon fonctionnement de gestlic ne sont pas créées"
	fi
}

# Fonction pour vérifier la création du fichier de conservation des comptes
function compte {
	i=0
	if [ -f "/home/archives" ] ; then
		i=i+1
	fi
	if [ i=1 ] ; then
		echo "Le fichier de conservation des compte est créé."
	else
		echo "Le fichier de conservation des compte n'est pas créé."
	fi
}

# Fonction pour vérifier la création des groupes
function groupes {
	i=0
	if getent group l2i >/dev/null ; then 
		i=i+1
	fi
	if getent group l22i >/dev/null ; then 
		i=i+1
	fi
	if getent group l12i >/dev/null ; then 
		i=i+1
	fi
	if getent group l32i >/dev/null ; then 
		i=i+1
	fi
	if getent group l2mi >/dev/null ; then 
		i=i+1
	fi
	if getent group l1mpi >/dev/null ; then 
		i=i+1
	fi
	if getent group lin >/dev/null ; then 
		i=i+1
	fi
	if getent group l3in >/dev/null ; then 
		i=i+1
	fi
	if getent group licence >/dev/null ; then 
		i=i+1
	fi
	if getent group l2 >/dev/null ; then 
		i=i+1
	fi
	if getent group l1 >/dev/null ; then 
		i=i+1
	fi
	if getent group l3 >/dev/null ; then 
		i=i+1
	fi
	if [ i=12 ] ; then 
		echo "Les groupes sont créés."
	else
		echo "Les groupes ne sont pas créés."
	fi
}

# Fonction pour un utilisateur de ses groupes d'appartenance
function sortie {
	sudo deluser $2 licence
	case $1 in
		l12i) 
			sudo deluser $2 l2i
			sudo deluser $2 l1
			sudo deluser $2 l12i
			;;
		l22i)  
			sudo deluser $2 l2i
			sudo deluser $2 l2
			sudo deluser $2 l22i
			;;
		l32i)  
			sudo deluser $2 l2i
			sudo deluser $2 l3
			sudo deluser $2 l32i
			;;
		l1mpi)  
			sudo deluser $2 lin
			sudo deluser $2 l1
			sudo deluser $2 l1mpi
			;;
		l2mi)  
			sudo deluser $2 lin
			sudo deluser $2 l2
			sudo deluser $2 l2mi
			;;
		l3in)  
			sudo deluser $2 lin
			sudo deluser $2 l3
			sudo deluser $2 l3in
			;;
    	esac
}

# Fonction pour créer les liens symboliques de l'utilisateur après migration 
function link {
	sudo ln -s /home/partages/licence /home/licence/$2/$1/$3/licence
	case $1 in
		l12i) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/l1
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l12i /home/licence/$2/$1/$3/l12i
			;;
		l22i) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/l2
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l22i /home/licence/$2/$1/$3/l22i
			;;
		l32i) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/l3
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/l2i
			sudo ln -s /home/partages/l32i /home/licence/$2/$1/$3/l32i
			;;
		l1mpi) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/l1
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l1mpi /home/licence/$2/$1/$3/l1mpi
			;;
		l2mi) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/l2
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l2mi /home/licence/$2/$1/$3/l2mi
			;;
		l3in) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/l3
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/lin
			sudo ln -s /home/partages/l3in /home/licence/$2/$1/$3/l3in
			;;  
	esac
}

# Fonction pour supprimer les liens symboliques d'un utilisateur avant migration
function links {
	sudo rm -r -f /home/licence/$2/$1/$3/licence
	case $1 in
		l12i) 
			sudo rm -r -f /home/licence/$2/$1/$3/l1
			sudo rm -r -f /home/licence/$2/$1/$3/l2i
			sudo rm -r -f /home/licence/$2/$1/$3/l12i
			;;
		l22i) 
			sudo rm -r -f /home/licence/$2/$1/$3/l2
			sudo rm -r -f /home/licence/$2/$1/$3/l2i
			sudo rm -r -f /home/licence/$2/$1/$3/l22i
			;;
		l32i) 
			sudo rm -r -f /home/licence/$2/$1/$3/l3
			sudo rm -r -f /home/licence/$2/$1/$3/l2i
			sudo rm -r -f /home/licence/$2/$1/$3/l32i
			;;
		l1mpi) 
			sudo rm -r -f /home/licence/$2/$1/$3/l1
			sudo rm -r -f /home/licence/$2/$1/$3/lin
			sudo rm -r -f /home/licence/$2/$1/$3/l1mpi
			;;
		l2mi) 
			sudo rm -r -f /home/licence/$2/$1/$3/l2
			sudo rm -r -f /home/licence/$2/$1/$3/lin
			sudo rm -r -f /home/licence/$2/$1/$3/l2mi
			;;
		l3in) 
			sudo rm -r -f /home/licence/$2/$1/$3/l3
			sudo rm -r -f /home/licence/$2/$1/$3/lin
			sudo rm -r -f /home/licence/$2/$1/$3/l3in
			;;  
	esac
}

# Fonction pour éditer le fichier d'aide
function texte {
	echo "gestlic executé sans option ni paramètres fait une vérification de l’installation, c’est l’équivalent de l’option −−check ." >> ~/.gestlic/aide.txt
	echo "Les options offertes par la commande sont les suivantes :" >> ~/.gestlic/aide.txt
	echo "-a (−−add)” pour l’ajout d’un compte. cette option fonctionne avec un paramètre obligatoire, le nom du compte a créer." >> ~/.gestlic/aide.txt
	echo "−m (− − migrate) permet de migrer un étudiant d’une classe vers une classe supérieure." >> ~/.gestlic/aide.txt
	echo "-u (− − update) permet de modifier les caractéristiques d’un compte. Il ne permettra de modifier que les nom et prénoms de l’étudiant." >> ~/.gestlic/aide.txt
	echo "-L (−−Lock) permet de désactiver un compte. Cet opération permet de désactiver le compte, il bloque juste l’accés au compte sans modifier sa configuration." >> ~/.gestlic/aide.txt
	echo "-U (−−Unlock) permet de réactiver un compte." >> ~/.gestlic/aide.txt
	echo "-d (− − delete) permet de supprimer un compte de gestlic." >> ~/.gestlic/aide.txt
	echo "-c (−−check) fait une vérification de la configuration de gestlic." >> ~/.gestlic/aide.txt
	echo "−−help affiche un texte d’aide à l’image des commandes de base linux." >> ~/.gestlic/aide.txt
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Fonction pour créer l'utilisateur
function utilisateur {
    nom=$1
    read -p "Donner votre prénom: " prenom
    
    read -p "Donner votre login: " log
    while grep -q "$log" ~/.gestlic/compte.txt; do
	read -p "Donner un autre login" log
    done
    
    echo "1: l12i"
    echo "2: l22i"
    echo "3: l32i"
    echo "4: l1mpi"
    echo "5: l2mi"
    echo "6: l3in"
    classe=$(class)
    
    niveau=$(niveau $classe)
    
    create_user $log $niveau $classe
    
    expiration_date=$(date -d "18 months" +"%Y-%m-%d")
    
    DATE=$(date +"%Y-%m-%d")
    echo "$DATE"
    
    groupe $classe $log
    
    liens $classe $niveau $log
    
    affichage $1 $prenom $log $classe $niveau $DATE $expiration_date
    
    sudo echo $1:$prenom:$log:$classe:$DATE:$expiration_date:$niveau >> ~/.gestlic/compte.txt
}

# Fonction pour mettre à jour les informations de l'utilisateur
function updat { 
    read -p "Donnez le login de l'étudiant a modifier : " log
    modifier $log
}

# Fonction pour désactiver un compte
function lock {
	read -p "Donnez le login de l'étudiant a désactiver : " log
	bloque $log
}

# Fonction pour activer un compte
function unlock {
	read -p "Donnez le login de l'étudiant a désactiver : " log
	debloque $log
}

# Fonction pour supprimer un utilisateur de gestlic
function delete_student {
	read -p "Donnez le login de l'étudiant à supprimer : " log
	until grep -q "$log" ~/.gestlic/compte.txt ; do
		read -p "Donnez le login de l'étudiant à supprimer : " log
	done

	local ligne=$(grep "^.*:${log}:" ~/.gestlic/compte.txt)
	local nom_classe=$(echo "$ligne" | cut -d ":" -f 4)
	local nom_niveau=$(echo "$ligne" | cut -d ":" -f 7)

	sortie $nom_classe $log
	
	sudo mv /home/licence/$nom_niveau/$nom_classe/$log /home/archives
	bloque $log
}

# Fonction pour vérifier la configuration de gestlic
function chek {
	archi
	partages
	compte
	cache
	groupes
}

# Fonction pour migrer un utilisateur d'une classe à une autre 
function migrat {
	read -p "Donnez le login de l'étudiant à migrer : " log
	until grep -q "$log" ~/.gestlic/compte.txt ; do
		read -p "Donnez le login de l'étudiant à supprimer : " log
	done
	
	local ligne=$(grep "^.*:${log}:" ~/.gestlic/compte.txt)
	local nom_name=$(echo "$ligne" | cut -d ":" -f 1)
	local nom_surname=$(echo "$ligne" | cut -d ":" -f 2)
	local nom_date=$(echo "$ligne" | cut -d ":" -f 5)
	local nom_classe=$(echo "$ligne" | cut -d ":" -f 4)
	local nom_niveau=$(echo "$ligne" | cut -d ":" -f 7)
	
	echo "1: l12i"
    	echo "2: l22i"
    	echo "3: l32i"
    	echo "4: l1mpi"
    	echo "5: l2mi"
    	echo "6: l3in"
    	while true; do
		read -p "Donner la nouvelle classe (1-6): " r
		if [[ $r -ge 1 && $r -le 6 ]]; then
		    break
		fi
    	done

	case $r in
		1) cl="l12i";;
		2) cl="l22i";;
		3) cl="l32i";;
		4) cl="l1mpi";;
		5) cl="l2mi";;
		6) cl="l3in";;
	esac
	
	case $cl in
		l12i|l1mpi) niv="licence1";;
		l22i|l2mi) niv="licence2";;
		l32i|l3in) niv="licence3";;
    	esac
    	
    	links $nom_classe $nom_niveau $log
    	
    	expiration_date=$(date -d "12 months" +"%Y-%m-%d")
    	sudo chage -E $expiration_date $log
    	
    	new_ligne="$nom_name:$nom_surname:$log:$cl:$nom_date:$expiration_date:$niv"
    	sed -i "s|${ligne}|${new_ligne}|" ~/.gestlic/compte.txt
	
	sudo mv /home/licence/$nom_niveau/$nom_classe/$log /home/licence/$niv/$cl
	
	new_home="/home/licence/$niv/$cl/$log"
	sudo usermod -d $new_home $log
	
	link $cl $niv $log	
	
	case $nom_classe in
		l12i) 
			sudo deluser $log l1
			sudo deluser $log l2i
			sudo deluser $log l12i
			;;
		l22i)  
			sudo deluser $log l2
			sudo deluser $log l2i
			sudo deluser $log l22i
			;;
		l32i) 
			sudo deluser $log l3
			sudo deluser $log l2i
			sudo deluser $log l32i
			;;
		l1mpi)  
			sudo deluser $log l1
			sudo deluser $log lin
			sudo deluser $log l1mpi
			;;
		l2mi)  
			sudo deluser $log l2
			sudo deluser $log lin
			sudo deluser $log l2mi
			;;
		l3in)  
			sudo deluser $log l3
			sudo deluser $log lin
			sudo deluser $log l3in
			;;
    	esac
    	case $cl in
		l12i) sudo usermod -aG l1,l12i,l2i $log ;;
		l22i) sudo usermod -aG l2,l22i,l2i $log ;;
		l32i) sudo usermod -aG l3,l32i,l2i $log ;;
		l1mpi) sudo usermod -aG l1,l1mpi,lin $log ;;
		l2mi) sudo usermod -aG l2,l2mi,lin $log ;;
		l3in) sudo usermod -aG l3,l3in,lin $log ;;
    	esac
}

# Fonction d'aide
function aide {
	texte
	cat ~/.gestlic/aide.txt
}

case $1 in
	-a|--add)utilisateur $2 ;;
	-m|--migrate)migrat ;;
	-u|--update)updat ;;
	-L|--Lock)lock ;;
	-U|--Unlock)unlock ;;
	-d|--delete)delete_student ;;
	-c|--check|"")chek ;;
	--help|*)aide ;;
esac
