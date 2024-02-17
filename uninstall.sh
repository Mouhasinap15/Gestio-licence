# Suppression des répertoires de l'architecture proposée.
function archidel {
	sudo rm -r /home/licence 
}

# Suppression des groupes de l'architecture proposée.
function groupedel {
	sudo groupdel licence
	sudo groupdel l1
	sudo groupdel l2
	sudo groupdel l3
	sudo groupdel l2i
	sudo groupdel lin
	sudo groupdel l12i
	sudo groupdel l22i
	sudo groupdel l32i
	sudo groupdel l1mpi
	sudo groupdel l2mi
	sudo groupdel l3in
}

# Suppression des répertoires de partages.
function partdel {
	sudo rm -r /home/partages
}

# Suppression du fichier caché et de fichier utile au bon fonctionnement de gestlic.
function fichiercache {
	sudo rm -r ~/.gestlic
}

# Désinstallation de gestlic.
function repdel {
	sudo rm -r /home/archives
	fichiercache
	archidel
	groupedel
	partdel
}
repdel
