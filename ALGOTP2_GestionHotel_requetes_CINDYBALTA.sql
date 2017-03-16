--Nombre de clients
SELECT 	count(CLI_ID) 
FROM 	T_CLIENT;

--Les clients triés sur le titre et le nom
SELECT 		* 
FROM 		T_CLIENT
ORDER BY 	TIT_CODE, CLI_NOM asc;

--Les clients triés sur le libellé du titre et le nom
SELECT 		CLI_ID, T_TITRE.TIT_LIBELLE, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE
FROM 		T_CLIENT, T_TITRE
WHERE		T_CLIENT.TIT_CODE = T_TITRE.TIT_CODE
ORDER BY 	TIT_LIBELLE, CLI_NOM asc;

--Les clients commençant par 'B'
SELECT	*
FROM	T_CLIENT
WHERE	CLI_NOM like "B%";

--Les clients homonymes


--Nombre de titres différents
SELECT	count(TIT_CODE)
FROM	T_TITRE;

--Nombre d'enseignes
SELECT	count(distinct(CLI_ENSEIGNE))
FROM	T_CLIENT;

--Les clients qui représentent une enseigne 
SELECT	TIT_CODE, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE
FROM	T_CLIENT
WHERE	CLI_ENSEIGNE not null;

--Les clients qui représentent une enseigne de transports
SELECT	TIT_CODE, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE
FROM	T_CLIENT
WHERE	upper(CLI_ENSEIGNE) like upper("%transport%");

--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés


--Nombre d'emails
SELECT	count(EML_ID)
FROM	T_EMAIL;

--Client sans email 
SELECT	TIT_CODE, CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE 
FROM	T_CLIENT
WHERE	CLI_ID NOT IN	(	
							SELECT 	CLI_ID
							FROM	T_EMAIL
						);

--Clients sans téléphone 
SELECT	TIT_CODE, CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE 
FROM	T_CLIENT
WHERE	CLI_ID NOT IN	(	
							SELECT 	CLI_ID
							FROM	T_TELEPHONE
						);

--Les phones des clients
SELECT	TIT_CODE, T_TELEPHONE.CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE, T_TELEPHONE.TEL_NUMERO
FROM	T_CLIENT, T_TELEPHONE
WHERE	T_CLIENT.CLI_ID = T_TELEPHONE.CLI_ID;

--Ventilation des phones par catégorie



--Les clients ayant plusieurs téléphones
SELECT	TIT_CODE, T_TELEPHONE.CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE
FROM	T_CLIENT as C, T_TELEPHONE
WHERE	C.CLI_ID = T_TELEPHONE.CLI_ID
AND		(
			SELECT 	count(CLI_ID)
			FROM	T_TELEPHONE
			WHERE	C.CLI_ID = CLI_ID
		) > 1;

--Clients sans adresse:
SELECT	TIT_CODE, CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE 
FROM	T_CLIENT
WHERE	CLI_ID NOT IN	(	
							SELECT 	CLI_ID
							FROM	T_ADRESSE
						);

--Clients sans adresse mais au moins avec mail ou phone 
SELECT	TIT_CODE, CLI_ID, CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE 
FROM	T_CLIENT
WHERE	CLI_ID NOT IN	(	
							SELECT 	CLI_ID
							FROM	T_ADRESSE
						)
AND		(
			CLI_ID IN	(
							SELECT 	CLI_ID
							FROM	T_TELEPHONE
						)
			OR
			CLI_ID IN	(
							SELECT 	CLI_ID
							FROM	T_EMAIL
						)
		);

--Dernier tarif renseigné
SELECT	max(TRF_DATE_DEBUT), TRF_TAUX_TAXES, TRF_PETIT_DEJEUNE
FROM	T_TARIF;

--Tarif débutant le plus tôt 
SELECT	min(TRF_DATE_DEBUT), TRF_TAUX_TAXES, TRF_PETIT_DEJEUNE
FROM	T_TARIF;

--Différentes Années des tarifs
SELECT	distinct(strftime('%Y',TRF_DATE_DEBUT))
FROM	T_TARIF;

--Nombre de chambres de l'hotel 
SELECT	count(CHB_ID)
FROM	T_CHAMBRE;

--Nombre de chambres par étage
SELECT		count(CHB_ID)
FROM		T_CHAMBRE
GROUP BY	CHB_ETAGE;

--Chambres sans telephone
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_POSTE_TEL IS NULL;

--Existence d'une chambre n°13 ?
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_NUMERO = 13;
	-- Non, il n'y a pas de chambre n°13


--Chambres avec sdb
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_BAIN = 1;

--Chambres avec douche
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_DOUCHE = 1;

--Chambres avec WC
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_WC = 1;

--Chambres sans WC séparés
SELECT	*
FROM	T_CHAMBRE
WHERE	CHB_ID NOT IN 	(
							SELECT	CHB_ID
							FROM	T_CHAMBRE
							WHERE	CHB_WC = 1
						);

--Quels sont les étages qui ont des chambres sans WC séparés ?
SELECT	CHB_ETAGE
FROM	T_CHAMBRE
WHERE	CHB_ID NOT IN 	(
							SELECT	CHB_ID
							FROM	T_CHAMBRE
							WHERE	CHB_WC = 1
						);

--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant
SELECT		CHB_NUMERO, CHB_ETAGE, (CHB_BAIN+CHB_DOUCHE+CHB_WC) as NBR_SANITAIRE
FROM		T_CHAMBRE
ORDER BY	NBR_SANITAIRE asc;

--Chambres les plus équipées et leur capacité
SELECT	CHB_NUMERO, CHB_ETAGE, CHB_COUCHAGE, (CHB_BAIN+CHB_DOUCHE+CHB_WC) as NBR_SANITAIRE
FROM	T_CHAMBRE
WHERE	NBR_SANITAIRE = (
							SELECT	max(CHB_BAIN+CHB_DOUCHE+CHB_WC)
							FROM	T_CHAMBRE
							
						);				

--Repartition des chambres en fonction du nombre d'équipements et de leur capacité
SELECT		COUNT(CHB_ID) as NBR_CHB, (CHB_BAIN+CHB_DOUCHE+CHB_WC) as NBR_SANITAIRE, CHB_COUCHAGE
FROM		T_CHAMBRE
GROUP BY	NBR_SANITAIRE;

--Nombre de clients ayant utilisé une chambre
SELECT	COUNT(DISTINCT(CLI_ID))
FROM	TJ_CHB_PLN_CLI;

--Clients n'ayant jamais utilisé une chambre (sans facture)

--Nom et prénom des clients qui ont une facture

--Nom, prénom, telephone des clients qui ont une facture

--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients

--Répartition des factures par mode de paiement (libellé)

--Répartition des factures par mode de paiement 

--Différence entre ces 2 requêtes ? 

--Factures sans mode de paiement 

--Repartition des factures par Années

--Repartition des clients par ville

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année

--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition

--Facture dates et Délai entre date de paiement et date d'édition de la facture