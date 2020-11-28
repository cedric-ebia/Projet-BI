/************Script permettant de créer les différentes tables**********************/
/*****************************************/
/* Numero de version : 1.0.0             */
/* Date Livraison    : 19/11/2020        */
/*****************************************/
/*******************************************************************************************************************************************/
/* Programme            : script1.sql (Script permettant de créer les différentes tables SAS et DWH)				                       */
/* Périmètre            : Datawarehouse Prêt à porter                                                                                      */
/*                                                                                                                                         */
/* Domaine              : Retail SIAD                                                                                                      */
/*                                                                                                                                         */
/*                                                                                                                                         */
/* Auteur               : Groupe 2                                          														       */
/* Date                 : 19/11/2020 Initialisation                                                                                        */
/*-----------------------------------------------------------------------------------------------------------------------------------------*/

/*Création de la table qui servira à recevoir le fichier avant son intégration dans les tables SAS*/
create table base_source
    (lignes varchar(2000));
/**Exemple de chargement de nos fichiers dans la table base_source***/



/**** Points d'information dans le code ****/

/*VARCHAR is reserved by Oracle to support distinction between NULL and empty string in future, as ANSI standard prescribes.

varchar does not distinguish between a NULL and empty string, and never will.

If you rely on empty string and NULL being the same thing, you should use varchar.*/



---- 1) Création des différentes tables SAS;
/*SAS client*/

create table sas_client(
    /*type_ligne,*/
    action varchar(1),
    cle_compte varchar(45),
    cle_client varchar(45), 
    status number(5),
    type number(5),
    civilite number(5),
    Prenom varchar(255),
    Nom varchar(255),
    date_anniversaire varchar(10),
    Sexe number(5),
    Couleur_preferee number(5),
    Fidelite number(5),
    id_source number);

--- 2) SAS_compte;

create table sas_compte(
    /*type_ligne,*/
    action varchar(1)
    cle_compte varchar(45),
    status number(5),
    Type number(5),
    magasin_rattachement number(9),
    id_source number);
    
--- 3) SAS_Telephone;

create table sas_telephone (
    /*type_ligne,*/
    action varchar(1),
    cle_client varchar(45),
    phone varchar(45),
    status number(5),
    favori number(5),
    type number(5),
    id_source number);
    
--- 4) SAS_email;

create table sas_email(
    type_ligne varchar(3),
    action varchar(1),
    cle_client varchar(45),
    email varchar(255),
    status number (5),
    id_source number);
    
--- 5)SAS_Adresse;
create table sas_adresse (
    /*type_ligne,*/
    action varchar(1),
    cle_client varchar(45),
    status number(5),
    ligne1 varchar(255),
    ligne2 varchar(255),
    ligne3 varchar(255),
    ligne4 varchar(255),
    ligne5 varchar(255),
    ville varchar(50),
    code_postal varchar(10),
    pays number(5),
    qualite number(5),
    id_source number);
    
---  6) SAS_source;

create table sas_source (
    /*type_ligne,*/
    id_source number,
    type_fichier varchar(20),
    version number(2),
    date varchar(30)
    source varchar(30),
    sequence varchar(6),
    Date_integration date,
    statut_integration varchar(10),
    Motif varchar(255),
    constraint pk_source primary key (id_source);

/*** Incrémentation de l'idsource dans la table sas_source***/
--- Séquence;
create sequence seq_source increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_source before
    insert on sas_source
    for each row
    begin
        select seq_source into: new.id_source
        from dual;
    end;
/**** Fin de l'incrémentation pour l'idsource ****/

--- Création des différentes tables du datawarehouse;

--- DWH_compte;

create table dwh_compte(
    id_compte number,
    cle_compte varchar(45),
    status number(5),
    Type number(5),
    magasin_rattachement number(9),
    id_source number,
    constraint pk_dwh_compte primary key (id_compte);

/*** Incrémentation de l'id_compte ***/

--- Séquence;
create sequence seq_compte increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_compte before
    insert on dwh_compte
    for each row
    begin
        select seq_compte into: new.id_compte
        from dual;
    end;
/*** Fin de l'incrément pour l'id_compte***/
/*** Ajout clé étrangère (contrainte d'intégrité) pour id_source ***/



--- DWH_client;

create table dwh_client(
    id_client number,
    id_compte number,
    status number(5),
    type number(5),
    civilite number(5),
    Prenom varchar(255),
    Nom varchar(255),
    date_anniversaire varchar(10),
    Sexe number(5),
    Couleur_preferee number(5),
    Fidelite number(5),
    id_source number,
    constraint pk_dwh_client primary key (id_client));

/*** Incrément de l'id_client ***/   

create sequence seq_client increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_client before
    insert on dwh_client
    for each row
    begin
        select seq_client into: new.id_client
        from dual;
    end;


/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource  ***/



--- DWH_Telephone;

create table dwh_telephone (
    id_client number,
    phone varchar(45),
    status number(5),
    favori number(5),
    type number(5),
    id_source number,
    constraint pk_dwh_telephone primary key(id_client, type));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_telephone;
    add constraint fk_telephone foreign key (id_client) references dwh_client(id_client)
--- DWH_email;

create table dwh_email (
    id_client number,
    cle_client varchar(45),
    email varchar(255),
    status number (5),
    id_source number,
    constraint pk_dwh_email primary key(id_client));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_email;
add constraint fk_email foreign key (id_client) references dwh_client(id_client;)
--- DWH_Adresse;

create table dwh_adresse (
    id_client number,
    status number(5),
    ligne1 varchar(255),
    ligne2 varchar(255),
    ligne3 varchar(255),
    ligne4 varchar(255),
    ligne5 varchar(255),
    ville varchar(50),
    code_postal varchar(10),
    pays number(5),
    qualite number(5),
    id_source number,
    constraint pk_dwh_adresse primary key (id_client));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_adresse;
    add constraint fk_adresse foreign key (id_client) references dwh_client(id_client); 
/*test bis*/
