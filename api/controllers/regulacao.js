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
 *  Consulta informacoes de UTI
 * 
 */
module.exports = {
    getFilaLeitosUTI: (req, res)=>{
        //console.log('URL==>', req.url);
        var sql = `
        select 
        --ses,
        prioridade,
        to_char(dataentradafila, 'DD/mm/YYYY') as dataentradafila,
        horaentradafila,
        nr_passagem,
        --tipouti,
        --idade,
        --pr,
        --nt,
        --mj,
        --ci,
        --vm,
        --av,
        --inc,
        ---hd,
        --encaminhamento,
        --tipofila.
        --num_cartaosus as cartao_sus,
        --nome ,
        --tipoleito || '-' || 
        subtipoleito
        --,
        --subtipoleito,
        --resumoclinico,
        --telcontato ,
        --localentradauti,
        --to_char(i_data_extracao, 'DD/mm/YYYY HH12:MI:SS') as i_data_extracao,
        ---i_unidade as unidade,
        FROM st_stick.tab_crdf_fila_uti`;
        
   //console.log('SQL==>', sql,'<==');
        pool.query(sql,null, (err, result)=>{
            if(err) {
              console.error('error running query', errq);
              res.status(500).send({codret: -1, mensagem: err.message});
              //res.status(500).send(err);
              return;
            }
            var r= result.rows.map(row => Object.assign({}, row));
            r.unshift({
              prioridade: "Prioridade",
              dataentradafila: "Data da Entrada na fila da UTI",
              horaentradafila: "Hora de Entrada na fila da UTI", 
              nr_passagem: "Número da Passagem", 
              //tipouti: "Tipo de Leito" ,
              //ses: "SES",
              //idade: "Idade",
              //pr: "PR",
              //nt: "NT",
              //mj: "MJ",
              //ci: "CI",
              //vm: "VM",  
              //ac: "AC",  
              //inc: "INC",  
              //hd: "HD",  
              //encaminhamento: "Encaminhamento",  
              //tipofila: "Tipo de Fila",  
              //cartao_sus: "Cartão SUS",  
              //nome: "Nome",  
              tipoleito: "Tipo de Leito" //,  
              //subtipoleito: "Subtipo de Leito",  
              //resumoclinico: "Resumo Clínico",  
              //telcontato: "Contato",  
              //localentradauti: "Local de Entrada da UTI",  
              //data_extracao: "Data Extração",  
              //unidade: "Unidade",   
            });
            res.send(r);
          });
    }
}