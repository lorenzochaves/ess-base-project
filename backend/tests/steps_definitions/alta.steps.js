// npx cucumber-js --require tests/steps_definitions/alta.steps.js tests/features/alta.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const request = require('supertest');
const chai = require('chai');
const app = require('../../src/app.js');

const expect = chai.expect;

let response;

// Passos de Given
Given('que existem noticias populares nas categorias {string}', function (categoria) {
  // Simulação de pré-condição
});

Given('que existem pratos populares na categoria {string}', function (categoria) {
  // Simulação de pré-condição
});

Given('que existem itens populares na categoria {string}', function (categoria) {
  // Simulação de pré-condição
});

Given('que existem conteúdos com alta visualização e interação de todos os usuários nas categorias {string} e {string}', function (categoria1, categoria2) {
  // Simulação de pré-condição
});

// Passos de When
When('eu faço uma requisição GET para {string}', async function (endpoint) {
  response = await request(app)
    .get(endpoint)
    .set('Accept', 'application/json');
});

Then('o código de status da resposta deve ser {string}', function (status) {
  expect(response.status).to.equal(parseInt(status));
});

Then('os conteúdos devem ser organizados por popularidade, com base nas visualizações recentes', function () {
  //expect(response.body).to.be.an('array');
  for (let i = 1; i < response.body.length; i++) {
    const prevItem = response.body[i - 1];
    const currentItem = response.body[i];
    const prevPopularity = calculateAdjustedPopularity(prevItem.views, getDaysDifference(prevItem.publicationDate));
    const currentPopularity = calculateAdjustedPopularity(currentItem.views, getDaysDifference(currentItem.publicationDate));
    expect(prevPopularity).to.be.at.least(currentPopularity);
  }
});

Then('devo receber uma lista dos pratos em alta', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('devo receber uma lista das noticias em alta', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('devo receber os conteúdos mais populares entre todos os usuários', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

// Função auxiliar para calcular a diferença em dias
function getDaysDifference(dateString) {
  const publicationDate = new Date(dateString);
  const now = new Date();
  const timeDifference = now - publicationDate;
  return Math.floor(timeDifference / (1000 * 60 * 60 * 24));
}

// Função auxiliar para calcular popularidade ajustada pelo tempo
function calculateAdjustedPopularity(views, daysDifference) {
  return daysDifference === 0 ? views : views / daysDifference;
}
