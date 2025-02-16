//npx cucumber-js --require tests/steps_definitions tests/features/createNews.feature
const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');

const expect = chai.expect;

let response;

// Cenário: Criar notícia com sucesso
Given('o usuario administrador quer postar uma nova noticia', function () {
  // Nada precisa ser feito aqui, pois é apenas um contexto
});

When('o usuario envia uma requisição POST para {string} com um JSON com title {string}, subtitle {string}, body {string}', async function (path, title, subtitle, body) {
  response = await request(app)
    .post(path)
    .send({ title, subtitle, body })
    .set('Accept', 'application/json');
});

Then('o sistema retorna um status code {int}', function (statusCode) {
  expect(response.status).to.equal(statusCode);
});

Then('a resposta contera title {string}, subtitle {string}, body {string}', function (title, subtitle, body) {
  expect(response.body).to.have.property('title', title);
  expect(response.body).to.have.property('subtitle', subtitle);
  expect(response.body).to.have.property('body', body);
});

// Cenário: Criar notícia sem título
When('o usuario envia uma requisição POST para {string} com um JSON com subtitle {string}, body {string}', async function (path, subtitle, body) {
  response = await request(app)
    .post(path)
    .send({ subtitle, body })
    .set('Accept', 'application/json');
});

Then('a resposta contera a mensagem de erro {string}', function (errorMessage) {
  expect(response.body.error || response.body.errors).to.include(errorMessage);
});

// Cenário: Criar notícia com corpo acima do limite
When('o usuario envia uma requisição POST para {string} com um JSON com title {string}, subtitle {string}, body {string}', async function (path, title, subtitle, body) {
  response = await request(app)
    .post(path)
    .send({ title, subtitle, body })
    .set('Accept', 'application/json');
});

// Cenário: Editar notícia existente
Given('o usuario administrador quer editar uma noticia', function () {
  // Nada precisa ser feito aqui, pois é apenas um contexto
});

Given('existe uma notícia com ID {string}', function (id) {
  // Nada precisa ser feito aqui, pois é apenas um contexto
});

When('o usuario envia uma requisição PUT para {string} com um JSON com title {string}, subtitle {string}, body {string}', async function (path, title, subtitle, body) {
  response = await request(app)
    .put(path)
    .send({ title, subtitle, body })
    .set('Accept', 'application/json');
});

// Cenário: Excluir notícia com sucesso
Given('o usuario administrador quer excluir uma noticia', function () {
  // Nada precisa ser feito aqui, pois é apenas um contexto
});

When('o usuario envia uma requisição DELETE para {string}', async function (path) {
  response = await request(app)
    .delete(path)
    .set('Accept', 'application/json');
});