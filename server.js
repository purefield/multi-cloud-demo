'use strict';

const express = require('express');

// Constants
const PORT = process.env.PORT || 8080;
const HOST = '0.0.0.0';
const VERSION = 1
const HOST = process.env.HOSTNAME    || 'unknown';
const ENV  = process.env.ENVIRONMENT || 'unknown';

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Hello World! v${VERSION} in ${ENV} on $(HOST)\n`);
});

app.listen(PORT, HOST => 
    console.log(`Running v${VERSION} in ${ENV} on http://${HOST}:${PORT}`)
);
