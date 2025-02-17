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

When('o usuario faz uma requisição POST para {string} com os dados:', async function (path, dadosTabela) {
  const dados = dadosTabela.rowsHash();
  response = await request(app)
    .post(path)
    .send(dados)
    .set('Accept', 'application/json');
});

When('o usuario faz uma requisição PUT para {string} com os dados:', async function (path, dadosTabela) {
  const dados = dadosTabela.rowsHash();
  response = await request(app)
    .put(path)
    .send(dados)
    .set('Accept', 'application/json');
});

When('o usuario faz uma requisição DELETE para {string}', async function (path) {
  response = await request(app)
    .delete(path)
    .set('Accept', 'application/json');
});

Then('uma lista com todas as noticias cadastradas e retornada', function () {
  expect(response.body).to.be.an('array');
  expect(response.body.length).to.be.greaterThan(0);
  response.body.forEach(noticia => {
    expect(noticia).to.have.property('id');
    expect(noticia).to.have.property('title');
    expect(noticia).to.have.property('subtitle');
    expect(noticia).to.have.property('body');
    expect(noticia).to.have.property('publicationDate');
    expect(noticia).to.have.property('views');
  });
});

Then('a noticia e retornada', function () {
  expect(response.body).to.be.an('object');
  expect(response.body).to.have.property('id');
  expect(response.body).to.have.property('title');
  expect(response.body).to.have.property('subtitle');
  expect(response.body).to.have.property('body');
  expect(response.body).to.have.property('publicationDate');
  expect(response.body).to.have.property('views');
});

Then('o sistema retorna um status code {int}', function (status) {
  expect(response.status).to.equal(status);
});

Then('a resposta contera uma noticia com title {string}', function (titulo) {
  expect(response.body.title).to.equal(titulo);
});

Then('a resposta contera uma mensagem de erro {string}', function (mensagem) {
  expect(response.body.error).to.equal(mensagem);
});

Then('a resposta contera uma mensagem {string}', function (mensagem) {
  expect(response.body.message).to.equal(mensagem);
});


