// npx cucumber-js --require tests/steps_definitions tests/features/createNews.feature
const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');


const expect = chai.expect;

let response;

Given('existem noticias cadastradas no sistema', function () {
});

Given('existe uma noticia cadastrada no sistema com ID {string}', function (ID) {
});

When('o usuario faz uma requisição GET para {string}', async function (path) {
  response = await request(app)
    .get(path)
    .set('Accept', 'application/json');
});

