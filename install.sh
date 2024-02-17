# Création des répertoires de l'architecture proposée avec les bon droits.
function archiadd {
	sudo mkdir /home/licence ; sudo chmod 750 /home/licence
	sudo mkdir /home/licence/licence1 ; sudo chmod 750 /home/licence/licence1
	sudo mkdir /home/licence/licence2 ; sudo chmod 750 /home/licence/licence2
	sudo mkdir /home/licence/licence3 ; sudo chmod 750 /home/licence/licence3
	sudo mkdir /home/licence/licence1/l12i ; sudo chmod 750 /home/licence/licence1/l12i
	sudo mkdir /home/licence/licence1/l1mpi ; sudo chmod 750 /home/licence/licence1/l1mpi
	sudo mkdir /home/licence/licence2/l22i ; sudo chmod 750 /home/licence/licence2/l22i
	sudo mkdir /home/licence/licence2/l2mi ; sudo chmod 750 /home/licence/licence2/l2mi
	sudo mkdir /home/licence/licence3/l32i ; sudo chmod 750 /home/licence/licence3/l32i
	sudo mkdir /home/licence/licence3/l3in ; sudo chmod 750 /home/licence/licence3/l3in
}

# Création des groupes de l'architecture proposée.
function groupe {
	sudo addgroup licence
	sudo addgroup l2
	sudo addgroup l1
	sudo addgroup l3
	sudo addgroup l2i
	sudo addgroup l12i
	sudo addgroup l22i
	sudo addgroup l32i
	sudo addgroup l1mpi
	sudo addgroup l2mi
	sudo addgroup l3in
	sudo addgroup lin
}

# Création des répertoires de partages avec les bon droits.
function partage {
	sudo mkdir /home/partages ; sudo chmod 700 /home/partages ; sudo chown root:root /home/partages
	sudo mkdir /home/partages/licence ; sudo chmod 770 /home/partages/licence ; sudo chown root:licence /home/partages/licence
	sudo mkdir /home/partages/l2 ; sudo chmod 770 /home/partages/l2 ; sudo chown root:licence /home/partages/l2
	sudo mkdir /home/partages/l1 ; sudo chmod 770 /home/partages/l1 ; sudo chown root:l1 /home/partages/l1
	sudo mkdir /home/partages/l3 ; sudo chmod 770 /home/partages/l3 ; sudo chown root:l3 /home/partages/l3
	sudo mkdir /home/partages/l2i ; sudo chmod 770 /home/partages/l2i ; sudo chown root:l2i /home/partages/l2i
	sudo mkdir /home/partages/l12i ; sudo chmod 770 /home/partages/l12i ; sudo chown root:l12i /home/partages/l12i
	sudo mkdir /home/partages/l22i ; sudo chmod 770 /home/partages/l22i ; sudo chown root:l22i /home/partages/l22i
	sudo mkdir /home/partages/l32i ; sudo chmod 770 /home/partages/l32i ; sudo chown root:l32i /home/partages/l32i
	sudo mkdir /home/partages/l1mpi ; sudo chmod 770 /home/partages/l1mpi ; sudo chown root:l1mpi /home/partages/l1mpi
	sudo mkdir /home/partages/l2mi ; sudo chmod 770 /home/partages/l2mi ; sudo chown root:l2mi /home/partages/l2mi
	sudo mkdir /home/partages/l3in ; sudo chmod 770 /home/partages/l3in ; sudo chown root:l3in /home/partages/l3in
	sudo mkdir /home/partages/lin ; sudo chmod 770 /home/partages/lin ; sudo chown root:lin /home/partages/lin
}

# Création du fichier caché et de fichier utile au bon fonctionnement de gestlic.
function fichiercacher {
	sudo mkdir ~/.gestlic ; sudo chmod 777 ~/.gestlic ; sudo chown muhamed:muhamed ~/.gestlic
	sudo touch ~/.gestlic/compte.txt ; sudo chmod 777 ~/.gestlic/compte.txt ; sudo chown muhamed:muhamed ~/.gestlic/compte.txt
}

# Configuration de base de gestlic.
function repertoire {
	sudo mkdir /home/archives ; sudo chmod 770 /home/archives ; sudo chown root:root /home/archives
	fichiercacher
	archiadd
	groupe
	partage
}
repertoire
