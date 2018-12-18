const nodemailer = require('nodemailer');
//const config_param = require('../helpers/config')();
const config_param = require('../helpers/config')();

module.exports = {
    sendEmail: (req, res)=>{
        let smtp = config_param['smtp'] || process.env.SMTP;
        let from = config_param['from'] || process.env.FROM || 'salasituacao@saude.df.gov.br';
        let transporter = nodemailer.createTransport({
            host: smtp,
            port: 25,
            secure: false,
            tls: { rejectUnauthorized: false }
            });

        let option = {
                from: from,
                to: req.body.to,
                subject: req.body.subject,
                html: req.body.text
              };
        if('cc' in req.body){
            option['cc'] = req.body.cc;
        }
        if('bcc' in req.body){
            option['bcc'] = req.body.bcc;
        }
        console.log('Body==>', req.body);
        try{
            if(smtp){
                transporter.sendMail(
                    option, function(error, info){
                    if (error) {
                    console.log('Erro:',error);
                    res.status(500).send({codret: 1001, mensagem: 'Erro no envio'});
                    } else {
                    console.log('Email enviado: ' + info.response);
                    res.send({mensagem: 'Email enviado: ' + info.response});
                    } 
                });
            }else{
                res.status(500).send({codret: 1002, mensagem: 'Não existe endereço SMTP configurado'})
            }
        }catch(error){
            console.log('ERRO==>', error);
            res.status(500).send({codret: 1003, mensagem: error});
        }
        
    }
}
