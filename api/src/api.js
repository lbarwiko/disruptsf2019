import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';
import redis from 'redis';
import cors from 'cors';

import config from './config.js';
import router from './app/routes.js';

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
var client = new plaid.Client(
    PLAID_CLIENT_ID,
    PLAID_SECRET,
    PLAID_PUBLIC_KEY,
    plaid.environments[PLAID_ENV],
    { version: '2018-05-22' }
);

// Initialize Express
var app = express();

app.use(cors());

app.use(morgan('combined'));
// get all data/stuff of the body (POST) parameters
app.use(bodyParser.json()); // parse application/json 
app.use(bodyParser.urlencoded({ extended: true })); // parse application/x-www-form-urlencoded
app.use(bodyParser.json({ type: 'application/vnd.api+json' })); // parse application/vnd.api+json as json

app.use(express.static('public'));
app.set('view engine', 'ejs');

var client = redis.createClient();

client.on("error", function (err) {
    console.log("Error " + err);
});

app.use('/', router(client, config));

const server = app.listen(config.port, () => {
    const { address, port } = server.address();
    console.log(`Listening at http://${address}:${port}`);
});

app.get('/auth', function (request, response, next) {
    response.render('index.ejs', {
        PLAID_PUBLIC_KEY: PLAID_PUBLIC_KEY,
        PLAID_ENV: PLAID_ENV,
    });
});

app.post('/get_access_token', function (request, response, next) {
    PUBLIC_TOKEN = request.body.public_token;
    client.exchangePublicToken(PUBLIC_TOKEN, function (error,
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
        prettyPrintResponse(tokenResponse);
        response.json({
            access_token: ACCESS_TOKEN,
            item_id: ITEM_ID,
            error: false
        });
    });
});

export default app;