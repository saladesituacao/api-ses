-- stage -> cnex (create database stage;)
-- dbsistemas -> dbcomum  (create database dbsistemas; create schema dbcomum;)
---------------------------------------------
--  dbsalasituacao | dbmgi  | tb_aplicacao
--   Column    |         Type          |                                 Modifiers
--------------+-----------------------+---------------------------------------------------------------------------
-- co_aplicacao | integer               | not null default nextval('dbmgi.tb_aplicacao_co_aplicacao_seq'::regclass)
-- ds_aplicacao | character varying(50) | not null
--Indexes:
--    "tb_aplicacao_pkey" PRIMARY KEY, btree (co_aplicacao)
--Referenced by:
--    TABLE "dbmgi.tb_perfil" CONSTRAINT "fk_tb_perfil_co_aplicacao" FOREIGN KEY (co_aplicacao) REFERENCES dbmgi.tb_aplicacao(co_aplicacao)

create table dbcomum.tb_aplicacao (
    co_aplicacao serial not null,
    ds_aplicacao varchar(50) not null,
    constraint tb_aplicacao_pkey primary key (co_aplicacao)
);

insert into dbcomum.tb_aplicacao (ds_aplicacao) values ('MGI');
insert into dbcomum.tb_aplicacao (ds_aplicacao) values ('SESPLAN');
insert into dbcomum.tb_aplicacao (ds_aplicacao) values ('PROSEI');
insert into dbcomum.tb_aplicacao (ds_aplicacao) values ('SIGECH');
insert into dbcomum.tb_aplicacao (ds_aplicacao) values ('GESTOR');

--     Column      |          Type          |                              Modifiers
------------------+------------------------+---------------------------------------------------------------------
-- co_perfil        | integer                | not null default nextval('dbmgi.tb_perfil_co_perfil_seq'::regclass)
-- ds_sigla         | character(3)           | not null
-- ds_titulo        | character varying(50)  | not null
-- ds_perfil        | character varying(255) | not null
-- st_perfil        | boolean                | not null default true
-- st_exige_unidade | boolean                | not null default false
-- co_aplicacao     | integer                | not null
--Indexes:
 --   "tb_perfil_pkey" PRIMARY KEY, btree (co_perfil)
--Foreign-key constraints:
--    "fk_tb_perfil_co_aplicacao" FOREIGN KEY (co_aplicacao) REFERENCES dbmgi.tb_aplicacao(co_aplicacao)
--Referenced by:
--    TABLE "dbmgi.tb_user_mgi" CONSTRAINT "fk_tb_user_mgi_co_perfil" FOREIGN KEY (co_perfil) REFERENCES dbmgi.tb_perfil(co_perfil)

CREATE TABLE dbcomum.tb_perfil (
    co_perfil serial NOT NULL,
    ds_sigla character(3) NOT NULL,
    ds_titulo character varying(50) NOT NULL,
    ds_perfil character varying(255) NOT NULL,
    st_perfil boolean DEFAULT true NOT NULL,
    st_exige_unidade boolean DEFAULT false NOT NULL,
    co_aplicacao integer NOT NULL,
    CONSTRAINT tb_perfil_pkey PRIMARY KEY (co_perfil),
    CONSTRAINT fk_tb_perfil_co_aplicacao FOREIGN KEY (co_aplicacao) REFERENCES dbcomum.tb_aplicacao(co_aplicacao)
);

insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('ADM','Administrador do Sistema MGI','O administrador do sistema é responsável por gerenciar permissões e checar dadosdo sistema.','f',1);
insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('GES','Gestor da área','O gestor da área é responsável por manter informações de indicadores específicosda área.','t',1);
insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('EQA','Membro da equipe das áreas','Membros de equipes são responsáveis por alimentar o sistema com informações de indicadores específicas da área.','t', 1);
insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('ADM','Administrador','Administrador do SESPLAN ','f',2);
insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('CAD','Cadastrador','Cadastrador de informações','f',2);
insert into dbcomum.tb_perfil (ds_sigla, ds_titulo, ds_perfil, st_exige_unidade, co_aplicacao) values ('CON','Consulta','Consulta a dados do SESPLAN','f',2);

--       Table "dbmgi.tb_status_aprovacao"
--  Column   |          Type          | Modifiers
-----------+------------------------+-----------
-- co_status | integer                | not null
-- ds_status | character varying(255) | not null
--Indexes:
--    "tb_status_aprovacao_pkey" PRIMARY KEY, btree (co_status)
--Referenced by:
--    TABLE "dbmgi.tb_user_mgi" CONSTRAINT "fk_tb_user_mgi_co_situacao" FOREIGN KEY (co_situacao_perfil) REFERENCES dbmgi.tb_status_aprovacao(co_status)
CREATE TABLE dbcomum.tb_status_aprovacao (
    co_status integer NOT NULL,
    ds_status character varying(255) NOT NULL,
    CONSTRAINT tb_status_aprovacao_pkey PRIMARY KEY (co_status)
);

insert into dbcomum.tb_status_aprovacao (co_status, ds_status) values (0,'Em análise');
insert into dbcomum.tb_status_aprovacao (co_status, ds_status) values (1,'Aprovado');
insert into dbcomum.tb_status_aprovacao (co_status, ds_status) values (2,'Negado');

-- Tabelas de cargo

CREATE TABLE dbcomum.tb_cargo (
    co_cargo integer NOT NULL,
    ds_cargo character varying(255) NOT NULL,
    ds_descricao character varying(255),
    st_ativo boolean DEFAULT 'T' NOT NULL,
    CONSTRAINT tb_cargo_pkey PRIMARY KEY (co_cargo)
);
CREATE UNIQUE INDEX uq_tb_cargo ON dbcomum.tb_cargo USING btree (ds_cargo);

insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (1, 'CONSULTOR');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (2, 'TECNICO');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (3, 'SUBSECRETARIO');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (4, 'DIRETORIA');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (5, 'ASSESSORIA');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (6, 'COORDENACAO');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (7, 'SECRETARIO DE SAUDE');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (8, 'GERENCIA');
insert into dbcomum.tb_cargo (co_cargo, ds_cargo) values (9, 'CHEFIA');

-- tb_unidade
--     Column     |          Type          |                               Modifiers
----------------+------------------------+-----------------------------------------------------------------------
-- co_unidade     | integer                | not null default nextval('dbmgi.tb_unidade_co_unidade_seq'::regclass)
-- ds_sigla       | character varying(50)  | not null
-- ds_nome        | character varying(255) | not null
-- ds_email       | character varying(100) |
-- ds_telefone    | character varying(50)  |
-- ds_competencia | text                   |
-- ds_atividade   | text                   |
-- co_unidade_pai | integer                |
-- nu_nivel       | integer                |
-- st_informal    | boolean                | default false
--Indexes:
--    "tb_unidade_pkey" PRIMARY KEY, btree (co_unidade)
--    "ux_tb_unidade_ds_sigla" UNIQUE, btree (ds_sigla)
--Foreign-key constraints:
--    "tb_unidade_co_unidade_pai_fkey" FOREIGN KEY (co_unidade_pai) REFERENCES dbmgi.tb_unidade(co_unidade)
--Referenced by:
--    TABLE "dbmgi.tb_indicador_responsavel_gerencial" CONSTRAINT "fk_tb_indicador_responsavel_gerencial_co_unidade" FOREIGN KEY (co_unidade) REFERENCES dbmgi.tb_unidade(co_unidade) ON DELETE RESTRICT
--    TABLE "dbmgi.tb_indicador_responsavel_tecnico" CONSTRAINT "fk_tb_indicador_responsavel_tecnico_co_unidade" FOREIGN KEY (co_unidade) REFERENCES dbmgi.tb_unidade(co_unidade) ON DELETE RESTRICT
--    TABLE "dbmgi.tb_user_mgi" CONSTRAINT "fk_tb_user_mgi_co_unidade" FOREIGN KEY (co_unidade) REFERENCES dbmgi.tb_unidade(co_unidade)
--    TABLE "dbmgi.tb_indicador" CONSTRAINT "tb_indicador_co_unidade_responsavel_fkey" FOREIGN KEY (co_unidade) REFERENCES dbmgi.tb_unidade(co_unidade)
--    TABLE "dbmgi.tb_unidade" CONSTRAINT "tb_unidade_co_unidade_pai_fkey" FOREIGN KEY (co_unidade_pai) REFERENCES dbmgi.tb_unidade(co_unidade)

CREATE TABLE dbcomum.tb_orgao (
    co_unidade integer NOT NULL,
    ds_sigla character varying(50) NOT NULL,
    ds_nome character varying(255) NOT NULL,
    ds_email character varying(100),
    ds_telefone character varying(50),
    ds_competencia text,
    ds_atividade text,
    co_unidade_pai integer,
    co_centro_custo varchar(50),
    nu_nivel integer,
    st_informal boolean DEFAULT false,
    CONSTRAINT tb_unidade_pkey PRIMARY KEY (co_unidade),
    CONSTRAINT tb_unidade_co_unidade_pai_fkey FOREIGN KEY (co_unidade_pai) REFERENCES dbcomum.tb_orgao(co_unidade)
);


CREATE SEQUENCE tb_unidade_co_unidade_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY tb_orgao ALTER COLUMN co_unidade SET DEFAULT nextval('tb_unidade_co_unidade_seq'::regclass);

CREATE TABLE dbcomum.tb_orgao_hierarquia (
    co_unidade integer NOT NULL,
    co_unidade_superior integer NOT NULL,
    CONSTRAINT tb_orgao_hierarquia_pkey PRIMARY KEY (co_unidade,co_unidade_superior),
    CONSTRAINT tb_orgao_hierarquia_unidade_fkey FOREIGN KEY (co_unidade) REFERENCES dbcomum.tb_orgao(co_unidade),
    CONSTRAINT tb_orgao_hierarquia_unidade_superior_fkey FOREIGN KEY (co_unidade_superior) REFERENCES dbcomum.tb_orgao(co_unidade)
);
----------------------------------
CREATE TABLE tb_orgao (
    cod_orgao integer NOT NULL,
    txt_sigla character varying(200) NOT NULL,
    cod_ativo integer DEFAULT 1 NOT NULL,
    cod_exibir_consulta integer DEFAULT 0 NOT NULL,
    txt_descricao character varying(500),
    txt_codigo character varying(50),
    cod_orgao_superior integer
);

copy (Select * From sesplan.tb_orgao order by txt_sigla) To '/tmp/orgao.csv' With CSV DELIMITER ',';

--                                                Table "dbmgi.tb_user_mgi"
--       Column        |            Type             |                              Modifiers
----------------------+-----------------------------+---------------------------------------------------------------------
-- co_user             | integer                     | not null default nextval('dbmgi.tb_user_mgi_co_user_seq'::regclass)
-- ds_cpf              | character(11)               | not null
-- ds_nome             | character varying(255)      | not null
-- ds_email            | character varying(100)      | not null
-- ds_ramal            | character varying(100)      |
-- ds_celular          | character varying(100)      |
-- ar_perfis           | character varying(20)[]     |
-- dt_inclusao         | timestamp without time zone | not null
-- dt_atualizacao      | timestamp without time zone |
 --ds_cargo            | character varying(100)      |
-- ds_login            | character varying(255)      | not null
-- dt_login            | timestamp without time zone | not null default now()
-- ds_telefone         | character varying(100)      |
-- co_unidade          | integer                     |
-- co_perfil           | integer                     | not null
-- dt_aprovacao_perfil | timestamp without time zone |
-- co_user_aprovacao   | integer                     |
--- co_situacao_perfil  | integer                     | not null default 0
-- co_sexo             | character(1)                | not null
--Indexes:
--    "tb_user_mgi_pkey" PRIMARY KEY, btree (co_user)
--    "tb_user_mgi_ds_cpf" UNIQUE, btree (ds_cpf)
--    "tb_user_mgi_ds_email" UNIQUE, btree (ds_email)
--    "tb_user_mgi_ds_login" UNIQUE, btree (ds_login)
--Foreign-key constraints:
--    "tb_user_mgi_pkey" PRIMARY KEY, btree (co_user)
--    "tb_user_mgi_ds_cpf" UNIQUE, btree (ds_cpf)
--    "tb_user_mgi_ds_email" UNIQUE, btree (ds_email)
--    "tb_user_mgi_ds_login" UNIQUE, btree (ds_login)
--Foreign-key constraints:
 --   "fk_tb_user_mgi_co_perfil" FOREIGN KEY (co_perfil) REFERENCES dbmgi.tb_perfil(co_perfil)
--    "fk_tb_user_mgi_co_situacao" FOREIGN KEY (co_situacao_perfil) REFERENCES dbmgi.tb_status_aprovacao(co_status)
--    "fk_tb_user_mgi_co_unidade" FOREIGN KEY (co_unidade) REFERENCES dbmgi.tb_unidade(co_unidade)
--    "fk_tb_user_mgi_co_user_aprovacao" FOREIGN KEY (co_user_aprovacao) REFERENCES dbmgi.tb_user_mgi(co_user)
--Referenced by:
--    TABLE "dbmgi.tb_user_mgi" CONSTRAINT "fk_tb_user_mgi_co_user_aprovacao" FOREIGN KEY (co_user_aprovacao) REFERENCES dbmgi.tb_user_mgi(co_user)
--    TABLE "dbmgi.tb_carga" CONSTRAINT "tb_carga_co_responsavel_fkey" FOREIGN KEY (co_responsavel) REFERENCES dbmgi.tb_user_mgi(co_user)

CREATE TABLE dbcomum.tb_user (
    co_user serial NOT NULL,
    ds_cpf character(11) NOT NULL,
    ds_nome character varying(255) NOT NULL,
    ds_email character varying(100) NOT NULL,
    ds_ramal character varying(100),
    ds_celular character varying(100),
    dt_inclusao timestamp without time zone NOT NULL,
    dt_atualizacao timestamp without time zone,
    co_cargo integer,
    ds_login character varying(255) NOT NULL,
    dt_login timestamp without time zone DEFAULT now() NOT NULL,
    ds_telefone character varying(100),
    co_unidade integer,
    co_sexo character(1) NOT NULL,
    constraint tb_user_pkey PRIMARY KEY  (co_user),
    constraint fk_tb_user_co_unidade FOREIGN KEY (co_unidade) REFERENCES dbcomum.tb_orgao(co_unidade),
    constraint fk_tb_userco_cargo FOREIGN KEY (co_cargo) REFERENCES dbcomum.tb_cargo(co_cargo)
);

insert into dbcomum.tb_user (ds_cpf, ds_nome, ds_email, ds_login, co_sexo, dt_inclusao) values ('53199260578','José Roberto Vasconcelos','joserobertovasconcelos@gmail.com', 'jroberto', 'M', now());

create table dbcomum.tb_user_perfil(
    co_user integer NOT NULL,
    co_perfil serial NOT NULL,
    dt_aprovacao_perfil timestamp without time zone,
    co_user_aprovacao integer,
    co_situacao_perfil integer DEFAULT 0 NOT NULL,
    constraint tb_user_perfili_pkey PRIMARY KEY  (co_user, co_perfil),
    constraint fk_tb_user_perfil_tb_perfil FOREIGN KEY (co_perfil) REFERENCES dbcomum.tb_perfil(co_perfil),
    constraint fk_tb_user_perfil_co_user FOREIGN KEY (co_user) REFERENCES dbcomum.tb_user(co_user),
        constraint fk_tb_user_mgi_co_situacao FOREIGN KEY (co_situacao_perfil) REFERENCES dbcomum.tb_status_aprovacao(co_status),
    constraint fk_tb_user_perfil_co_user_aprovacao FOREIGN KEY (co_user_aprovacao) REFERENCES dbcomum.tb_user(co_user)
);

select * from dbcomum.tb_aplicacao;
insert into dbcomum.tb_perfil(ds_sigla, ds_titulo, ds_perfil, co_aplicacao) values ('GES', 'Gestor', 'Gestor de dados',5);
insert into dbcomum.tb_user_perfil (co_user, co_perfil, dt_aprovacao_perfil,co_situacao_perfil) values (2, 8, now(), 1);
--- Transfere dados entre tabelas
--- pg_dump -U vasconcelos -h desenv.saude.df.gov.br -t dbauxiliares.tb_unidade stage |psql -h localhost -U postgres stage


alter table dbcomum.tb_user drop column ds_cargo;

--alter table dbcomum.tb_user add column co_cargo int not null;
alter table dbcomum.tb_user add constraint fk_tb_cargo_tb_user FOREIGN KEY (co_cargo) REFERENCES dbcomum.tb_cargo(co_cargo);


alter table dbcomum.tb_aplicacao add column ds_sigla varchar(5);

update dbcomum.tb_aplicacao set ds_sigla='MGI' where co_aplicacao=1;
update dbcomum.tb_aplicacao set ds_sigla='SPLAN' where co_aplicacao=2;
update dbcomum.tb_aplicacao set ds_sigla='PRSEI' where co_aplicacao=3;
update dbcomum.tb_aplicacao set ds_sigla='SGCH' where co_aplicacao=4;
update dbcomum.tb_aplicacao set ds_sigla='PRT' where co_aplicacao=5;

alter table dbcomum.tb_aplicacao alter column ds_sigla set not null;

create unique index ux_tb_aplicacao_ds_sigla on dbcomum.tb_aplicacao(ds_sigla);

insert into dbcomum.tb_user_perfil (co_user, co_perfil, co_situacao_perfil) values (4, 1, 0);