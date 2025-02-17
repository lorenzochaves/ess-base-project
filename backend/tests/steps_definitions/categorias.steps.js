// npx cucumber-js --require tests/steps_definitions/categorias.steps.js tests/features/categorias.feature
const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');


const expect = chai.expect;

let response;

Given('que existem categorias cadastradas no sistema', function () {
  // Os dados já estão no mock do sistema
});

Given('que existe uma categoria com id {string}', function (id) {
  // Os dados já estão no mock do sistema
});

Given('que existe uma categoria com nome {string}', function (nome) {
  // Os dados já estão no mock do sistema
});

Given('que a categoria não está vinculada a nenhum prato', function () {
  // Presume-se verdadeiro para o id 2 nos dados de teste
});

Given('que a categoria está vinculada a pratos', function () {
  // Presume-se verdadeiro para o id 1 nos dados de teste
});

When('eu faço uma requisição GET para {string}', async function (path) {
  response = await request(app)
    .get(path)
    .set('Accept', 'application/json');
});

When('eu faço uma requisição POST para {string} com os dados:', async function (path, dadosTabela) {
  const dados = dadosTabela.rowsHash();
  response = await request(app)
    .post(path)
    .send(dados)
    .set('Accept', 'application/json');
});

When('eu faço uma requisição PUT para {string} com os dados:', async function (path, dadosTabela) {
  const dados = dadosTabela.rowsHash();
  response = await request(app)
    .put(path)
    .send(dados)
    .set('Accept', 'application/json');
});

When('eu faço uma requisição DELETE para {string}', async function (path) {
  response = await request(app)
    .delete(path)
    .set('Accept', 'application/json');
});

Then('devo receber uma lista com todas as categorias cadastradas', function () {
  expect(response.body).to.be.an('array');
  expect(response.body.length).to.be.greaterThan(0);
  response.body.forEach(categoria => {
    expect(categoria).to.have.property('id');
    expect(categoria).to.have.property('name');
    expect(categoria).to.have.property('description');
  });
});

Then('devo receber os detalhes da categoria', function () {
  expect(response.body).to.be.an('object');
  expect(response.body).to.have.property('name');
  expect(response.body).to.have.property('id');
  expect(response.body).to.have.property('description');
});

Then('o código de status da resposta deve ser {int}', function (status) {
  expect(response.status).to.equal(status);
});

Then('a resposta deve conter uma categoria com nome {string}', function (nome) {
  expect(response.body.name).to.equal(nome);
});

Then('a resposta deve conter a mensagem de erro {string}', function (mensagem) {
  expect(response.body.error).to.equal(mensagem);
});

Then('a categoria deve ter sido excluída com sucesso', async function () {
  // Verifica se a categoria realmente foi excluída tentando buscá-la
  const checkResponse = await request(app)
    .get(`/categories/${response.body.id}`)
    .set('Accept', 'application/json');
  expect(checkResponse.status).to.equal(404);
});

Then('a categoria deve ter os campos atualizados corretamente', function () {
  expect(response.body).to.be.an('object');
  expect(response.body.name).to.equal('Carnes Premium');
  expect(response.body.description).to.equal('Carnes nobres');
});



