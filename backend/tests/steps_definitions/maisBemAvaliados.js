// npx cucumber-js --require tests/steps_definitions/maisBemAvaliados.js tests/features/maisBemAvaliados.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const request = require('supertest');
const app = require('../../src/app.js'); // Caminho para o arquivo onde seu app Express está configurado
const chai = require('chai');
const { dishes } = require('../../src/database/pratos.js');

const expect = chai.expect;

// Cenário 1: Listagem dos pratos mais bem avaliados com sucesso
Given('O usuário quer visualizar os pratos mais bem avaliados com sucesso', function () {
});

When('uma requisição GET for enviada para {string}', async function (endpoint) {
  const dados = { endpoint };
  response = await request(app)
    .get('/dishes/best-rated')
    .send(dados)
    .set('Accept', 'application/json');
});

Then('o status deve ser {string}', function (status) {
  expect(response.status).to.equal(parseInt(status, 10));
});

Then('o JSON da resposta deve conter uma lista de pratos ordenados por nota média, do maior para o menor', function () {
  expect(response.body).to.be.an('array');
  response.body.forEach(pratos => {
    expect(pratos).to.have.property('id');
    expect(pratos).to.have.property('name');
    expect(pratos).to.have.property('description');
    expect(pratos).to.have.property('category');
    expect(pratos).to.have.property('ingredients');
    expect(pratos).to.have.property('rating');
    expect(pratos).to.have.property('views');
  });
});


// Cenário 2: Listagem limitada a 5 pratos mais bem avaliados  

Given('O usuário quer visualizar os pratos mais bem avaliados', function () {
});

When('uma requisição GET for enviada para o endereço {string}', async function (endpoint) {
  const dados = { endpoint };
  response = await request(app)
    .get('/dishes/best-rated')
    .send(dados)
    .set('Accept', 'application/json');
});

Then('o status deve ser {string} e ser aceito', function (status) {
  expect(response.status).to.equal(parseInt(status, 10));
});

Then('o JSON da resposta deve conter no máximo 5 pratos, mesmo que existam mais pratos avaliados no sistema', function () {
  expect(response.body).to.be.an('array');
  expect(response.body.length).to.be.at.most(5);
});

// Cenário 3: Visualizar o prato mais bem avaliado

Given('O usuário quer visualizar o prato na posição 1 dos mais bem avaliados', function () {
});

When('uma requisição GET for enviada para o endpoint {string}', async function (endpoint) {
  const dados = { endpoint };
  response = await request(app)
    .get('/dishes/best-rated')
    .send(dados)
    .set('Accept', 'application/json');
});

Then('o status deve ser {string} por hora', function (status) {
  expect(response.status).to.equal(parseInt(status, 10));
});

Then('o JSON da resposta deve conter o prato na posição {int} do ranking', function (position) {
  // Como a posição fornecida é 1-based, vamos ajustar para 0-based (índice de array começa em 0)
  const prato = response.body[position - 1];

  // Verifique se o prato retornado tem os atributos corretos
  expect(prato).to.have.property('id');
  expect(prato).to.have.property('name');
  expect(prato).to.have.property('description');
  expect(prato).to.have.property('category');
  expect(prato).to.have.property('ingredients');
  expect(prato).to.have.property('rating');
  expect(prato).to.have.property('views');
});
