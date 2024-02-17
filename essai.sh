#!/bin/bash

#bash install.sh

function d {
	sudo usermod --lock $1
}

function niveau {
    case $1 in
        l12i|l1mpi) niv="licence1";;
        l22i|l2mi) niv="licence2";;
        l32i|l3in) niv="licence3";;
    esac
    
    echo $niv
}

function affichage {
    echo "Nom: $1"
    echo "Prénom: $2"
    echo "Login: $3"
    echo "Classe: $4"
    echo "Niveau: $5"
    echo "Date de création: " $6
    echo "Date d'expiration: " $7
}

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

function o {
	sudo usermod --unlock $1
}

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
    #sudo mv /home/$1 $new_home
    sudo usermod -d $new_home $1
    echo "Répertoire personnel déplacé vers $new_home."
}

function groupe {
	case $1 in
		l12i) sudo usermod -aG licence,l2i,l1,l12i $2 ;;
		l22i) sudo usermod -aG licence,l2i,l2,l22i $2;;
		l32i) sudo usermod -aG licence,l2i,l3,l32i $2;;
		l1mpi) sudo usermod -aG licence lin l1,l1mpi $2;;
		l2mi) sudo usermod -aG licence lin l2 l2mi $2;;
		l3in) sudo usermod -aG licence lin l3 l3in $2;;
    	esac
}

function liens {
	sudo ln -s /home/partages/licence /home/licence/$2/$1/$3/hf
	case $1 in
		l12i) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/p
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l12i /home/licence/$2/$1/$3/h
			;;
		l22i) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/h
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l22i /home/licence/$2/$1/$3/p
			;;
		l32i) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/h
			sudo ln -s /home/partages/l2i /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l32i /home/licence/$2/$1/$3/p
			;;
		l1mpi) 
			sudo ln -s /home/partages/l1 /home/licence/$2/$1/$3/h
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l1mpi /home/licence/$2/$1/$3/p
			;;
		l2mi) 
			sudo ln -s /home/partages/l2 /home/licence/$2/$1/$3/h
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l2mi /home/licence/$2/$1/$3/p
			;;
		l3in) 
			sudo ln -s /home/partages/l3 /home/licence/$2/$1/$3/h
			sudo ln -s /home/partages/lin /home/licence/$2/$1/$3/f
			sudo ln -s /home/partages/l3in /home/licence/$2/$1/$3/p
			;;  
	esac
}

function modifier_nom_prenom {
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

function tg {
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
		echo "Tous les répertoires de l'architecture proposée sont créées"
	else
		echo "Tous les répertoires de l'architecture proposée ne sont pas créées"
	fi
	
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
		echo "Tous les répertoires de partages sont créées"
	else
		echo "Tous les répertoires de partages ne sont pas créées"
	fi
	
	i=0
	if [ -f "~/.gestlic/compte.txt" ] ; then
		i=i+1
	fi
	if [ i=1 ] ; then
		echo "Le fichier caché et les fichiers utile au bon fonctionnement de gestlic sont créées"
	else
		echo "Le fichier caché et les fichiers utile au bon fonctionnement de gestlic ne sont pas créées"
	fi
	
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

function utilisateur {
    read -p "Donner votre nom: " nom
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
    
    affichage $nom $prenom $log $classe $niveau $DATE $expiration_date
    
    sudo echo $nom:$prenom:$log:$classe:$DATE:$expiration_date:$niveau >> ~/.gestlic/compte.txt
}

function update { 
    read -p "Donnez le login de l'étudiant a modifier : " log
    modifier_nom_prenom $log
}

function lock {
	read -p "Donnez le login de l'étudiant a désactiver : " log
	d $log
}

function unlock {
	read -p "Donnez le login de l'étudiant a désactiver : " log
	o $log
}

function delete_student() {
	read -p "Donnez le login de l'étudiant à supprimer : " log
	until grep -q "$log" ~/.gestlic/compte.txt ; do
		read -p "Donnez le login de l'étudiant à supprimer : " log
	done

	local ligne=$(grep "^.*:${log}:" ~/.gestlic/compte.txt)
	local nom_classe=$(echo "$ligne" | cut -d ":" -f 4)
	local nom_niveau=$(echo "$ligne" | cut -d ":" -f 7)

	sudo deluser $log licence

	case $nom_classe in
		l12i) 
			sudo deluser $log l2i
			sudo deluser $log l1
			sudo deluser $log l12i
			;;
		l22i)  
			sudo deluser $log l2i
			sudo deluser $log l2
			sudo deluser $log l22i
			;;
		l32i)  
			sudo deluser $log l2i
			sudo deluser $log l3
			sudo deluser $log l32i
			;;
		l1mpi)  
			sudo deluser $log lin
			sudo deluser $log l1
			sudo deluser $log l1mpi
			;;
		l2mi)  
			sudo deluser $log lin
			sudo deluser $log l2
			sudo deluser $log l2mi
			;;
		l3in)  
			sudo deluser $log lin
			sudo deluser $log l3
			sudo deluser $log l3in
			;;
    	esac

	sudo mv /home/licence/$nom_niveau/$nom_classe/$log /home/archives
	d $log
}

function check {
	tg
}

