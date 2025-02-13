// tests/setup/app.js
const express = require('express');
const categoriesRouter = require('../../src/routes/gerenciaCategorias');
const buscasRouter= require('../../src/routes/buscas');

const app = express();
app.use(express.json());
app.use('/categories', categoriesRouter);
app.use('/search', buscasRouter);

module.exports = app;