// npx cucumber-js --require tests/steps_definitions/criar_editar_user.js tests/features/criar_editar_user.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');

const expect = chai.expect;

let response;

Given('O usuário quer realizar um cadastro no sistema', function () {
  // O cadastro pode ser simulado diretamente nos testes com os dados fornecidos
});

Given('O usuário quer editar seu perfil no sistema', function () {
  // Pré-condição: o usuário já existe e deseja editar seu perfil
});

When('uma requisição POST com um JSON com nome {string}, login {string}, senha {string}', async function (nome, login, senha) {
  const dados = { nome, login, senha };
  response = await request(app)
    .post('/users')
    .send(dados)
    .set('Accept', 'application/json');
});

When('uma requisição POST com um JSON com nome {string}, senha {string}', async function (nome, senha) {
  const dados = { nome, senha };
  response = await request(app)
    .post('/users')
    .send(dados)
    .set('Accept', 'application/json');
});

When('uma requisição PUT para editar o id {int} com nome {string}, login {string}', async function (id, nome, login) {
  const dados = {id, nome, login };
  response = await request(app)
    .put(`/users/${id}`)
    .send(dados)
    .set('Accept', 'application/json');
});

When('uma requisição PUT para editar o id {int} não existente com nome {string}, e login {string}', async function (id, nome, login) {
  const dados = {id, nome, login };
  response = await request(app)
    .put(`/users/${id}`)
    .send(dados)
    .set('Accept', 'application/json');
});


When('esta requisição for enviada para {string}', async function (path) {
  // Isso já foi definido nas requisições acima, portanto, não é necessário aqui.
});

Then('o status da resposta deve ser {string}', function (status) {
  expect(response.status).to.equal(parseInt(status, 10));
});


Then('o JSON da resposta deve conter nome {string}, login {string}, senha {string}', function (nome, login, senha) {
  expect(response.body).to.have.property('nome', nome);
  expect(response.body).to.have.property('login', login);
  expect(response.body).to.have.property('senha', senha);
});

Then('o JSON deve conter message: {string}', function (error) {
  expect(response.body).to.have.property('error', error);
});

Then('o JSON da resposta deve conter id {int} com nome {string}, login {string}', function (id, nome, login) {
  expect(response.body).to.have.property('id', id);
  expect(response.body).to.have.property('nome', nome);
  expect(response.body).to.have.property('login', login);
});

Then('o JSON deve conter a message {string}', function (message) {
  expect(response.body).to.have.property('error', message);
});