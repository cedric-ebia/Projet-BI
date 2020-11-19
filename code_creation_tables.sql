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
    (lignes varchar2(2000));
/**Exemple de chargement de nos fichiers dans la table base_source***/



/**** Points d'information dans le code ****/

/*VARCHAR is reserved by Oracle to support distinction between NULL and empty string in future, as ANSI standard prescribes.

VARCHAR2 does not distinguish between a NULL and empty string, and never will.

If you rely on empty string and NULL being the same thing, you should use VARCHAR2.*/



---- 1) Création des différentes tables SAS;
/*SAS Compte*/

create table sas_client(
    /*type_ligne,*/
    action varchar2(1),
    cle_compte varchar2(45),
    cle_client varchar2(45), 
    status number(5),
    type number(5),
    civilite number(5),
    Prenom varchar2(255),
    Nom varchar2(255),
    date_anniversaire varchar2(10),
    Sexe number(5),
    Couleur_préférée number(5),
    Fidelite number(5),
    idsource number);

--- 2) SAS_compte;

create table sas_compte(
    /*type_ligne,*/
    action varchar2(1)
    cle_compte varchar2(45),
    status number(5),
    Type number(5),
    magasin_rattachement number(9),
    idsource number);
    
--- 3) SAS_Telephone;

create table sas_telephone (
    /*type_ligne,*/
    action varchar2(1),
    cle_client varchar2(45),
    phone varchar2(45),
    status number(5),
    favori number(5),
    type number(5),
    idsource number);
    
--- 4) SAS_email;

create table sas_email(
    type_ligne varchar2(3),
    action varchar2(1),
    cle_client varchar2(45),
    email varchar2(255),
    status number (5),
    idsource number);
    
--- 5)SAS_Adresse;
create table sas_adresse (
    /*type_ligne,*/
    action varchar2(1),
    cle_client varchar2(45),
    status number(5),
    ligne1 varchar2(255),
    ligne2 varchar2(255),
    ligne3 varchar2(255),
    ligne4 varchar2(255),
    ligne5 varchar2(255),
    ville varchar2(50),
    code_postal varchar2(10),
    pays number(5),
    qualité number(5),
    idsource number);
    
---  6) SAS_source;

create table sas_source (
    /*type_ligne,*/
    idsource number,
    type_fichier varchar2(20),
    version number(2),
    date varchar2(30)
    source varchar2(30),
    sequence varchar2(6),
    Date_integration date,
    statut_integration varchar2(10),
    Motif varchar2(255),
    constraint pk_source primary key (idsource);

/*** Incrémentation de l'idsource dans la table sas_source***/
--- Séquence;
create sequence seq_source increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_source before
    insert on sas_source
    for each row
    begin
        select seq_source into: new.idsource
        from dual;
    end;
/**** Fin de l'incrémentation pour l'idsource ****/

--- Création des différentes tables du datawarehouse;

--- DWH_compte;

create table dwh_compte(
    id_compte number,
    cle_compte varchar2(45),
    status number(5),
    Type number(5),
    magasin_rattachement number(9),
    idsource number,
    constraint pk_dwh_compte primary key (id_compte);


--- DWH_client;

create table dwh_client(
    id_client number,
    id_compte number,
    status number(5),
    type number(5),
    civilite number(5),
    Prenom varchar2(255),
    Nom varchar2(255),
    date_anniversaire varchar2(10),
    Sexe number(5),
    Couleur_préférée number(5),
    Fidelite number(5),
    idsource number,
    constraint pk_dwh_client primary key (id_client));

/** Au niveau de l'auto-incrément des différentes clés **/    

--- DWH_Telephone;

create table dwh_telephone (
    id_client number,
    phone varchar2(45),
    status number(5),
    favori number(5),
    type number(5),
    idsource number,
    constraint pk_dwh_telephone primary key(id_client, type));
    
--- DWH_email;

create table dwh_email (
    id_client number,
    cle_client varchar2(45),
    email varchar2(255),
    status number (5),
    idsource number,
    constraint pk_dwh_email primary key(id_client));


--- DWH_Adresse;

create table dwh_adresse (
    id_client number,
    status number(5),
    ligne1 varchar2(255),
    ligne2 varchar2(255),
    ligne3 varchar2(255),
    ligne4 varchar2(255),
    ligne5 varchar2(255),
    ville varchar2(50),
    code_postal varchar2(10),
    pays number(5),
    qualité number(5),
    idsource number,
    constraint pk_dwh_adresse primary key (id_client));