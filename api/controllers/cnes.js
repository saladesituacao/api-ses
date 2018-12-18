const pg = require('pg');
const config_param = require('../helpers/config')();

const config = {
    user: process.env.USER_DBSTAGE || config_param.stage.user, //env var: PGUSER
    database: process.env.DBSTAGE || config_param.stage.database, //env var: PGDATABASE
    password: process.env.PASSWORD_DBSTAGE || config_param.stage.password,
    host: process.env.HOSTDB || config_param.hostdb, // Server hosting the postgres database
    port: 5432, //env var: PGPORT
    max: 10, // max number of clients in the pool
    idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
  };

const pool = new pg.Pool(config);
pool.on('error', function (err, client) {
  console.error('idle client error', err.message, err.stack);
});
/**
 * 
 select DISTINCT  pcn.i_desc_regiao_saude_estab
     , pcn.i_desc_tp_unidade_cnes
     , pcn.i_estab_cnes    
     , pcn.i_desc_estab_cnes
     , pcn.i_bairro_estab_cnes
     , pcn.i_comp_estab_cnes
     , pcn.i_tel_estab_cnes
     , pcn.i_fax_estab_cnes
     , pcn.i_email_estab_cnes
from st_stage.tab_prof_cnes pcn
 where 
 (pcn.i_desc_regiao_saude_estab <>'Privado' and pcn.i_desc_regiao_saude_estab<>'Contratada')
order by  pcn.i_desc_regiao_saude_estab,
          pcn.i_desc_tp_unidade_cnes
 * 
 */
module.exports = {
    getCNES: (req, res)=>{
        //console.log('URL==>', req.url);
        var sql = `select tbu.i_desc_regiao_saude as regiao
        , tbd.cnes                       as cnes
        , tbd.cnes_desc                  as nome_fantasia
        , tbu.i_bairro        as bairro
        , tbu.i_endereco           as endereco
        , tbu.i_numero       as numero
        , CASE WHEN tbu.i_complemento ='N/C' THEN ' - '
          ELSE tbu.i_complemento
           END                           as complemento
        , tbu.i_cep           as CEP
        , tbu.i_telefone           as telefone
        , bb.desc_tipo_unidade_ses       as desc_tp_unidade
        , tlt.num_de_leitos as num_leitos
        , tbd.horario_func_ubs as horario_funcionamento
        , tbd.farmacia as tem_farmacia
        , tbd.atend_odont as atend_odontologico
        from (((dbauxiliares.tb_unidade tbd 
         LEFT JOIN st_stage.tab_cnes_unidades tbu on tbu.i_estab_cnes = tbd.cnes)
         LEFT JOIN dbauxiliares_cnes.tb_tipo_unidade bb ON bb.cod_tipo_unidade = tbd.cod_tipo_unidade)
         left outer join (select tlt.i_estab_cnes as cnes, NULLIF(SUM(tlt.i_qtd_existente),0) as num_de_leitos
               FROM st_stage.tab_cnes_leitos tlt
               GROUP BY tlt.i_estab_cnes) as tlt on tlt.cnes = tbd.cnes)
     where 
${(req.swagger.params.codigo.value?'tbd.cnes = $1 and ':'')} 
tbd.indica_sus='S'`;
        
   //console.log('SQL==>', sql,'<==');
        var cod = req.swagger.params.codigo.value? [req.swagger.params.codigo.value]: null;
        pool.query(sql,cod, (err, result)=>{
            if(err) {
              console.error('error running query', err);
              res.status(500).send({codret: -1, mensagem: err.message});
              return;
            }
            res.send({
                rows: result.rowCount, 
                list: result.rows.map(row => Object.assign({}, row)),
                meta: {
                    cnes: {name:"CNES", type:"string"},
                    nome_fantasia: {name:"Nome Fantasia", type:"string"},
                    bairro: {name:"Bairro", type:"string"},
                    endereco: {name:"Endere&ccedil;o", type:"string"},
                    numero:{name:"N&uacute;mero", type:"string"},
                    complemento: {name:"Complemento", type:"string"},
                    cep: {name:"CEP", type:"string"},
                    telefone: {name:"Telefone", type:"string"},
                    desc_tp_unidae:{name:"Tipo de Unidade", type:"string"},
                    num_leitos:{name:"N&uacute;mero de Leitos", type:"string"},
                    horario_funcionamento: {name:"Hor&aacute;rio de Funcionamento", type:"string"},
                    tem_farmacia: {name:"Tem Farmácia ?", type:"string"},
                    atend_odontologico: {name:"Atendimento Odontológico?", type:"string"}
               }
            });
          });
    }
}