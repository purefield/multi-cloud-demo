'use strict';

const express = require('express');

// Constants
const VERSION     = 2
const HOST        = '0.0.0.0';
const PORT        = process.env.PORT || 8080;
const HOSTNAME    = process.env.HOSTNAME    || 'unknown';
const ENV         = process.env.ENVIRONMENT || 'unknown';
const CLUSTER     = process.env.CLUSTER     || 'unknown';
const PLATFORM    = process.env.PLATFORM    || 'unknown';
const OCP_VERSION = process.env.VERSION     || 'unknown';

// App
const app = express();
const ver = `v${VERSION} in ${ENV.padStart(11, " ")}.${CLUSTER.padEnd(5, " ")} on ${PLATFORM.padStart(9, " ")} OCP v${OCP_VERSION} ${HOSTNAME}`;
app.get('/', (req, res) => {
  res.send(`Hello World! ${ver}\n`);
  console.log("Request at: " + new Date().toString());
});

app.listen(PORT, HOST => 
    console.log(`Running ${ver} on http://${HOST}:${PORT}`)
);
