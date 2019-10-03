import { Router } from 'express';

export default (redis, config) => {
  const router = Router();

  var APP_PORT = 8000;
  var PLAID_CLIENT_ID = config.keys.client_id;
  var PLAID_SECRET = config.keys.secret;
  var PLAID_PUBLIC_KEY = config.keys.key;
  var PLAID_ENV = config.keys.env;

  // We store the access_token in memory
  // In production, store it in a secure persistent data store
  var ACCESS_TOKEN = null;
  var PUBLIC_TOKEN = null;
  var ITEM_ID = null;

  var plaid = require('plaid');
  var plaidClient = new plaid.Client(
    PLAID_CLIENT_ID,
    PLAID_SECRET,
    PLAID_PUBLIC_KEY,
    plaid.environments[PLAID_ENV],
    { version: '2018-05-22' }
  );

  router.get('/', (req, res) => {
    res.send({
      version: '1.0',
      url: req.url
    })
  });

  router.get('/auth', function (request, response, next) {
    response.render('index.ejs', {
      PLAID_PUBLIC_KEY: PLAID_PUBLIC_KEY,
      PLAID_ENV: PLAID_ENV,
    });
  });

  router.post('/get_access_token', function (request, response, next) {
    PUBLIC_TOKEN = request.body.public_token;
    plaidClient.exchangePublicToken(PUBLIC_TOKEN, function (error,
      tokenResponse) {
      if (error != null) {
        var msg = 'Could not exchange public_token!';
        console.log(msg + '\n' + JSON.stringify(error));
        return response.json({
          error: msg
        });
      }
      ACCESS_TOKEN = tokenResponse.access_token;
      ITEM_ID = tokenResponse.item_id;
      console.log(tokenResponse);
      response.json({
        access_token: ACCESS_TOKEN,
        item_id: ITEM_ID,
        error: false
      });
    });
  });

  return router;

}