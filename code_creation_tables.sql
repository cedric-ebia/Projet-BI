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
    /*type_ligne*/
    action varchar(1),
    cle_compte varchar(45),
    cle_client varchar(45), 
    status number(5),
    type_client number(5),
    civilite number(5),
    Prenom varchar(255),
    Nom varchar(255),
    date_anniversaire varchar(10),
    Sexe number(5),
    Couleur_preferee number(5),
    Fidelite number(5),
    id_source number(10));

--- 2) SAS_compte;

create table sas_compte(
    /*type_ligne*/
    action varchar(1),
    cle_compte varchar(45),
    status number(5),
    Type_compte number(5),
    magasin_rattachement number(9),
    id_source number(10));
    
--- 3) SAS_Telephone;

create table sas_telephone (
    /*type_ligne*/
    action varchar(1),
    cle_client varchar(45),
    phone varchar(45),
    status number(5),
    favori number(5),
    type_telephone number(5),
    id_source number(10));
    
--- 4) SAS_email;

create table sas_email(
    /*type_ligne*/
    action varchar(1),
    cle_client varchar(45),
    email varchar(255),
    status number (5),
    id_source number(10));
    
--- 5)SAS_Adresse;
create table sas_adresse (
    /*type_ligne*/
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
    id_source number(10));
    
---  6) SAS_source;

create table sas_source(
    /*type_ligne*/
    id_source number(10),
    type_fichier varchar(20),
    version_fichier number(2),
    date_fichier varchar(30),
    source_fichier varchar(30),
    sequence_fichier varchar(6),
    Date_integration date,
    statut_integration varchar(10),
    Motif varchar(255),
    constraint pk_source primary key (id_source));



/** Ajout de l'id_source comme clé étrangère des différentes tables SAS **/

--  Pour la table sas_compte;
alter table sas_compte
    add constraint fk_sas_compte foreign key (id_source) references sas_source(id_source);

--  Pour la table sas_client;
alter table sas_client
    add constraint fk_sas_client foreign key (id_source) references sas_source(id_source);

--   Pour la table telephone;
alter table sas_telephone
    add constraint fk_sas_telephone foreign key(id_source) references sas_source(id_source);
    
--  ¨Pour la table adresse;
alter table sas_adresse
    add constraint fk_sas_adresse foreign key(id_source) references sas_source(id_source);
    
--  Pour la table email:
alter table sas_email
    add constraint fk_sas_email foreign key(id_source) references sas_source(id_source);

---- Validation de l'ensemble des modifications effectuées au niveau des tables sas;
commit;


--- Création des différentes tables du datawarehouse;

--- DWH_compte;

create table dwh_compte(
    id_compte number(10),
    cle_compte varchar(45),
    status number(5),
    Type_compte number(5),
    magasin_rattachement number(9),
    id_source number(10),
    constraint pk_dwh_compte primary key (id_compte));


--- DWH_client;

create table dwh_client(
    id_client number(10),
    id_compte number(10),
    status number(5),
    type_client number(5),
    civilite number(5),
    Prenom varchar(255),
    Nom varchar(255),
    date_anniversaire varchar(10),
    Sexe number(5),
    Couleur_preferee number(5),
    Fidelite number(5),
    id_source number(10),
    constraint pk_dwh_client primary key (id_client));



/*** Ajout clé étrangère (contrainte d'intégrité) pour id_compte  ***/
alter table dwh_client
    add constraint fk_client foreign key(id_compte) references dwh_compte(id_compte);


--- DWH_Telephone;

create table dwh_telephone (
    id_client number(10),
    phone varchar(45),
    status number(5),
    favori number(5),
    type_telephone number(5),
    id_source number(10),
    constraint pk_dwh_telephone primary key(id_client, type_telephone));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_telephone
    add constraint fk_telephone foreign key (id_client) references dwh_client(id_client);

--- DWH_email;

create table dwh_email (
    id_client number(10),
    cle_client varchar(45),
    email varchar(255),
    status number (5),
    id_source number(10),
    constraint pk_dwh_email primary key(id_client));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_email
    add constraint fk_email foreign key (id_client) references dwh_client(id_client);

--- DWH_Adresse;

create table dwh_adresse (
    id_client number(10),
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
    id_source number(10),
    constraint pk_dwh_adresse primary key (id_client));

/*** Ajout clé étrangère (contrainte d'intégrité) pour idsource et id_client ***/
alter table dwh_adresse
    add constraint fk_adresse foreign key (id_client) references dwh_client(id_client); 
    

--- Création des différents séquences et des triggers;

/*** Incrémentation de l'idsource dans la table sas_source***/

--- Séquence;
create sequence seq_source increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_source before
    insert on sas_source
    for each row
    begin
        select seq_source.nextval into: new.id_source
        from dual;
    end;
/**** Fin de l'incrémentation pour l'idsource ****/

/*** Incrémentation de l'id_compte ***/

--- Séquence;
create sequence seq_compte increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_compte before
    insert on dwh_compte
    for each row
    begin
        select seq_compte.nextval into: new.id_compte
        from dual;
    end;
/*** Fin de l'incrément pour l'id_compte***/

/*** Incrément de l'id_client ***/   
--- Sequence;
create sequence seq_client increment by 1 start with 1;
--- Trigger;
create or replace trigger trg_client before
    insert on dwh_client
    for each row
    begin
        select seq_client.nextval into: new.id_client
        from dual;
    end;


--- Création des différentes tables de transcodification;
    /* Trans_client */
create table trans_client(
    nom_variable varchar(30),
    codage number(5),
    libelle varchar(30)
);
    /* Trans_adresse */

create table trans_adresse(
    pays_code number(5),
    pays_libelle varchar(30)
);

    /* Trans_compte */
create table trans_compte(
    nom_variable varchar(30),
    codage number(5),
    libelle varchar(30)
);

    /* Trans_telephone */
create table trans_telephone(
    type_code number(5),
    type_libelle varchar(30)
);

--- Suppression des tables;
/*drop table base_source;
drop table sas_adresse;
drop table sas_client;
drop table sas_email;
drop table sas_telephone;
drop table sas_source;
drop table sas_compte;
drop table dwh_compte;
drop table dwh_client;
drop table dwh_telephone;
drop table dwh_email;
drop table dwh_adresse;*/

--- Suppression des triggers et des sequences;
/*drop trigger trg_client;
drop trigger trg_compte;
drop trigger trg_source;

drop sequence seq_source;
drop sequence seq_compte;
drop sequence seq_client;*/
                                           
/**** Script de création des différentes tables de rejet ****/

--- Pour la table de rejet compte;
create table rejet_compte(
    cle_compte varchar(45),
    status number(5),
    Type_compte number(5),
    magasin_rattachement number(9),
    id_source number(10));
    
/* Ajout de la clé étrangère concernant l'id_source */
alter table rejet_compte 
    add constraint fk_rejet_compte foreign key (id_source) references sas_source(id_source);
    ------------ Potentiellement, ajout des champs action;
    /*alter table rejet_compte
        add(action varchar(1));*/

--- Pour la table de rejet client;
create table rejet_client(
    cle_compte varchar(45),
    cle_client varchar(45), 
    status number(5),
    type_client number(5),
    civilite number(5),
    Prenom varchar(255),
    Nom varchar(255),
    date_anniversaire varchar(10),
    Sexe number(5),
    Couleur_preferee number(5),
    Fidelite number(5),
    id_source number(10));

/* Ajout de la clé étrangère concernant l'id_source */
alter table rejet_client 
    add constraint fk_rejet_client foreign key (id_source) references sas_source(id_source);
    ------------ Potentiellement, ajout des champs action;
    /*alter table rejet_client
        add(action varchar(1));*/

--- Pour la table de rejet_email;
create table rejet_email(
    cle_client varchar(45),
    email varchar(255),
    status number (5),
    id_source number(10));

/* Ajout de la clé étrangère concernant l'id_source */
alter table rejet_email 
    add constraint fk_rejet_email foreign key (id_source) references sas_source(id_source);
    ------------ Potentiellement, ajout des champs action;
    /*alter table rejet_email
        add(action varchar(1));*/   
        
--- Pour la table de rejet_telephone;
create table rejet_telephone(
    cle_client varchar(45),
    phone varchar(45),
    status number(5),
    favori number(5),
    type_telephone number(5),
    id_source number(10));
    
/* Ajout de la clé étrangère concernant l'id_source */
alter table rejet_telephone 
    add constraint fk_rejet_telephone foreign key (id_source) references sas_source(id_source);
    ------------ Potentiellement, ajout des champs action;
    /*alter table rejet_telephone
        add(action varchar(1));*/    

--- Pour la table de rejet_adresse;
create table rejet_adresse(
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
    id_source number(10));

/* Ajout de la clé étrangère concernant l'id_source */
alter table rejet_adresse
    add constraint fk_rejet_adresse foreign key (id_source) references sas_source(id_source);
    ------------ Potentiellement, ajout des champs action;
    /*alter table rejet_adresse
        add(action varchar(1));*/ 
commit;

