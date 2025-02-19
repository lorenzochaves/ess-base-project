// npx cucumber-js --require tests/steps_definitions tests/features/busca.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const request = require('supertest');
const chai = require('chai');
const app = require('../../src/app.js');

const expect = chai.expect;

let response;

// Passos de Given
Given('que existe um prato chamado {string}', { tags: '@busca' }, function (nomePrato) {
  // Passo narrativo
});

Given('que existem pratos cadastrados na categoria {string}', { tags: '@busca' }, function (categoria) {
  // Passo narrativo
});

Given('que existem pratos com diferentes avaliações', { tags: '@busca' }, function () {
  // Passo narrativo
});

Given('que existem pratos com diferentes números de visualizações', { tags: '@busca' }, function () {
  // Passo narrativo
});

Given('que existem pratos cadastrados com categorias e avaliações diversas', { tags: '@busca' }, function () {
  // Passo narrativo
});

Given('que não existem pratos cadastrados que atendam aos filtros aplicados', { tags: '@busca' }, function () {
  // Passo narrativo
});

Given('que existem filtros aplicados na search', { tags: '@busca' }, function () {
  // Passo narrativo
});

// Passos de When
When('eu faço uma requisição GET para {string} na busca', { tags: '@busca' }, async function (endpoint) {
  response = await request(app)
    .get(endpoint)
    .set('Accept', 'application/json');
  //console.log(`Requisição para ${endpoint}:`, response.status, response.body);
});

// When('eu faço uma requisição GET para {string} com os parâmetros:', { tags: '@busca' }, async function (endpoint) {
//   response = await request(app)
//     .get(endpoint)
//     .set('Accept', 'application/json');
//   //console.log(`Requisição para ${endpoint}:`, response.status, response.body);
// });

When('eu faço uma requisição GET para {string} sem parâmetros', { tags: '@busca' }, async function (endpoint) {
  response = await request(app)
    .get(endpoint)
    .set('Accept', 'application/json');
  //console.log(`Requisição para ${endpoint}:`, response.status, response.body);
});

// Passos de Then
Then('devo receber os detalhes do prato {string}', { tags: '@busca' }, function (nomePrato) {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
  expect(response.body[0].name).to.equal(nomePrato);
});

Then('devo receber uma lista de pratos da categoria {string}', { tags: '@busca' }, function (categoria) {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
  response.body.forEach(prato => {
    expect(prato.category).to.equal(categoria);
  });
});

Then('devo receber apenas pratos com nota igual ou superior a {float}', { tags: '@busca' }, function (notaMinima) {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
  response.body.forEach(prato => {
    expect(prato.rating).to.be.at.least(notaMinima);
  });
});

Then('devo receber uma lista com os {int} pratos mais vistos', { tags: '@busca' }, function (quantidade) {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').with.lengthOf(quantidade);
});

Then('devo receber os pratos que correspondem aos critérios aplicados', { tags: '@busca' }, function () {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('devo receber uma mensagem {string}', { tags: '@busca' }, function (mensagem) {
  //console.log('Debug - response:', response);
  expect(response.status).to.equal(404);
  expect(response.body).to.have.property('error', mensagem);
});

Then('devo receber todos os pratos cadastrados no sistema', { tags: '@busca' }, function () {
  //console.log('Debug - response:', response);
  // expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('o código de status das respostas deve ser {int}', { tags: '@busca' }, function (status) {
  //console.log('Debug - response:', response);
  expect(response.status).to.equal(status);
});