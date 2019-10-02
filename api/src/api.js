import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';
import redis from 'redis';
import cors from 'cors';

import config from './config.js';
import router from './app/routes.js';

// Initialize Express
var app = express();

app.use(cors());

app.use(morgan('combined'));
// get all data/stuff of the body (POST) parameters
app.use(bodyParser.json()); // parse application/json 
app.use(bodyParser.urlencoded({ extended: true })); // parse application/x-www-form-urlencoded
app.use(bodyParser.json({ type: 'application/vnd.api+json' })); // parse application/vnd.api+json as json

var client = redis.createClient();

client.on("error", function (err) {
    console.log("Error " + err);
});

app.use('/', router(client, config));

const server = app.listen(config.port, () => {
    const { address, port } = server.address();
    console.log(`Listening at http://${address}:${port}`);
});

  
export default app;