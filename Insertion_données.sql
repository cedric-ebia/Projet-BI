/**** Code exemple adéquat afin d'alimenter les différents champs ***/

/*Correction recup champs d'une table*/
SELECT 
  substr(BASE_SOURCE.LIGNES,
  (instr(BASE_SOURCE.LIGNES,'|',1,1)+1), 
  (instr(BASE_SOURCE.LIGNES,'|',1,2)-instr(BASE_SOURCE.LIGNES,'|',1,1)-1))  
from base_source;

--- En gros, la séquence est la suivante;
/* Séquence suivante: 1ere occurence pipe, 
2e occurence pipe, 1ere occurence pipe
Exemple ci-dessus= 1;2;1*/

------------------
/*Pour récupérer le dernier champ d'une table*/
SELECT substr(BASE_SOURCE.LIGNES,instr(BASE_SOURCE.LIGNES,'|',1,5)+1)
from base_source;

/*Séquence suivante: Trouver le rang du dernier pipe de la ligne
 Exemple ci-dessus=5*/


  /**** Les syntaxes fausses ****/
---recup champs;

/*to_number(substr(BASE_SOURCE.LIGNES,
  (instr(BASE_SOURCE.LIGNES,'|',1,2)+1),
  (instr(BASE_SOURCE.LIGNES,'|',1,3)-1)
  )*/

--- Récup dernier champ d'une table;
/*substr(BASE_SOURCE.LIGNES,
  (instr(BASE_SOURCE.LIGNES,'|',1,1)+1),
  (instr(BASE_SOURCE.LIGNES,'|',1,2)-instr(BASE_SOURCE.LIGNES,'|',1,1)-1))*/
  
