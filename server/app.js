const express = require('express');
const morgan = require('morgan');
const path = require('path');
const compression = require('compression');

const app = express();

// Set up logger
app.use(
  morgan(':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms')
);

// Enable compression
app.use(compression());

// Healthcheck
app.get('/healthcheck', (_,res) => res.sendStatus(200));

module.exports = app;