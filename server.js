'use strict';

const express = require('express');

// Constants
const VERSION  = 1
const HOST     = '0.0.0.0';
const PORT     = process.env.PORT || 8080;
const HOSTNAME = process.env.HOSTNAME    || 'unknown';
const ENV      = process.env.ENVIRONMENT || 'unknown';

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Hello World! v${VERSION} in ${ENV} on ${HOSTNAME}\n`);
});

app.listen(PORT, HOST => 
    console.log(`Running v${VERSION} in ${ENV} on http://${HOST}:${PORT}`)
);
