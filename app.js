'use strict';

var SwaggerExpress = require('swagger-express-mw');
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var subpath = express();
var config_param = require('./api/helpers/config')();
var swagger_config = require('./api/helpers/swagger-yaml')();
var path = require('path');
var context = process.env.CONTEXT || config_param.context || '';

module.exports = app; // for testing

var config = {
  appRoot: __dirname, // required config
  swaggerSecurityHandlers: require('./api/helpers/security')
};

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.get(context + '/swagger.yaml', (req,res,next)=>{
  //console.log('swagger', swagger_config);
  res.setHeader('content-type', 'application/json');

  swagger_config.host = process.env.HOST || config_param.host;
  swagger_config.info.title = config_param.title;
  swagger_config.info.description = config_param.description;

  
  res.send(swagger_config);
});

SwaggerExpress.create(config, function(err, swaggerExpress) {
  if (err) { throw err; }

  if(context){
    console.log('CONTEXT==>', context);
    app.use(context, subpath);
    //console.log('context==>', context, 'subpath', subpath);
    app.get('/', (req, res) => {
      res.redirect(path.join(context, 'docs'));
    })
    swaggerExpress.runner.swagger.host = process.env.HOST || config_param.host;

    swaggerExpress.runner.swagger.basePath = context;

    subpath.use(swaggerExpress.runner.swaggerTools.swaggerUi());
  }else{
    app.use(swaggerExpress.runner.swaggerTools.swaggerUi());
  }
  app.use((request, response, next) => {
    response.header('Access-Control-Allow-Origin', '*');
    response.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE, OPTIONS');
    response.header('Access-Control-Allow-Headers', 'Accept, Origin, Content-Type');
    response.header('Access-Control-Allow-Credentials', 'true');
    next();
  });
  app.use(express.static('public'));
  app.use(express.static('node_modules/redoc/dist'));

  // install middleware
  swaggerExpress.register(app);

  var port = process.env.PORT || config_param.port || 10010;
  console.log('Porta==>', port)
  app.listen(port);
});
