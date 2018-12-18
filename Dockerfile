FROM keymetrics/pm2:8-alpine

LABEL maintainer="joserobertovasconcelos@gmail.com" \
  description="Esta imagem exige os seguintes parâmetros: \
  \
  * COMPANY - Título da empresa \
  * DESCRIPTION - Descricao da API \
  * TITLE - Titulo da API \
  * PORT - Porta exposta na aplicacao \
  * CONTEXT - Contexto para a aplicacao \
  \
  ##DATABASE \
  \
  * HOSTDB - IP/Host da máquina de banco de dados \
  \
  ##DATABASE STAGE\
  \
  * USER_DBSTAGE - Usuário do banco da state \
  * DBSTAGE - Nome do banco de dados de stage \
  * PASSWORD_DBSTAGE - Senha do usuário do banco de dados de stage \
  \
  ## DATABASE SISTEMAS \
  \
  * DBSISTEMAS - Nome do banco de dados de sistemas \
  * USER_DBSISTEMAS - Usuário do banco de dados de sistemas \
  * PASSWORD_DBSISTEMAS - Senha do banco de dados de sistemas \
  * SCHEMA_DBSISTEMAS - Schema onde estão as tabelas \
  \
  Dependendo da escolha do tipo de esquema de validação: \
  \
  * SCHEMA_LOGIN - pode assumir os seguintes valores: ldap, scpa, local, windows. \
  \
  ##LDAP \
  \
  * URL - Url do serviço de LDAP.  Por exemplo: ldap://localhost. \
  * BIND_DN - Domain name do usuário que fará a consulta LDAP. Por exemplo: cn=admin, dc=exemplo, dc=com, dc=br \
  * BIND_CREDENTIALS - Senha do usuário de consulta LDAP \
  * SEARCH_BASE - Qual a base de busca do usuário do login no serviço de diretório. Por exemplo: DC=exemplo, DC=com, DC=br \
  * SEARCH_FILTER - Qual o filtro. Por exemplo: (uid={{username}}).  O nome username é o utilizado pelo sistema para retornar a identificação do usuário que está logando. \
  * NAMEFIELD - Nome do campo do ldap que retorna o nome (ex: givenName ) \
  * MAILFIELD - Nome do campo do ldap que retorna o email (ex: mail )"


RUN mkdir -p /var/opt/api && \
      mkdir /.pm2 && \
      apk add --no-cache curl && \
      chgrp -R 0 /.pm2 && \
	    chmod -R g+rwX /.pm2

ADD . /var/opt/api
WORKDIR /var/opt/api

EXPOSE 10010
USER 1001

CMD [ "pm2-runtime", "config/pm2-api.config.yaml"]