'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const VERSION = 5

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Hello World! v${VERSION}`);
});

app.listen(PORT, HOST => 
    console.log(`Running v${VERSION} on http://${HOST}:${PORT}`)
);
