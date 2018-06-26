const express = require('express');
const morgan = require('morgan');
const path = require('path');
const compression = require('compression');
const expressGraphQL = require('express-graphql');
const app = express();
const schema = require('./schema/schema');

// Set up logger
app.use(
  morgan(':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms')
);

// Enable compression
app.use(compression());

// Graphql Endpoint
app.use('/graphql', expressGraphQL({
  schema,
  graphiql: true
}));

// Healthcheck
app.get('/healthcheck', (_,res) => res.sendStatus(200));

// Default route
app.get('*', (_, res) => res.sendStatus(404));

module.exports = app;