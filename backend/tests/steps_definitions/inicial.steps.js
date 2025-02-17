const { Given, When, Then } = require('@cucumber/cucumber');
const request = require('supertest');
const chai = require('chai');
const app = require('../../src/app.js');

const expect = chai.expect;

let response;

Given('que existem pratos cadastrados na categoria {string}', function (categoria) {
  // Simulação de pré-condição
});

Given('que existem noticias cadastradas na categoria {string}', function (categoria) {
  // Simulação de pré-condição
});

Given('que existem conteúdos adicionados recentemente', function () {
  // Simulação de pré-condição
});

When('eu faço uma requisição GET para {string}', async function (endpoint) {
  response = await request(app)
    .get(endpoint)
    .set('Accept', 'application/json');
});

Then('o código de status da resposta deve ser {string}', function (status) {
  expect(response.status).to.equal(parseInt(status));
});

Then('os conteúdos devem ser organizados por popularidade dentro da categoria', function () {
  for (let i = 1; i < response.body.length; i++) {
    const prevItem = response.body[i - 1];
    const currentItem = response.body[i];
    const prevPopularity = calculateAdjustedPopularity(prevItem.views, getDaysDifference(prevItem.publicationDate));
    const currentPopularity = calculateAdjustedPopularity(currentItem.views, getDaysDifference(currentItem.publicationDate));
    expect(prevPopularity).to.be.at.least(currentPopularity);
  }
});

Then('os conteúdos devem ser organizados por relevância dentro da categoria', function () {
  for (let i = 1; i < response.body.length; i++) {
    const prevItem = response.body[i - 1];
    const currentItem = response.body[i];
    const prevRelevance = calculateAdjustedRelevance(prevItem.views, prevItem.rating, getDaysDifference(prevItem.publicationDate));
    const currentRelevance = calculateAdjustedRelevance(currentItem.views, currentItem.rating, getDaysDifference(currentItem.publicationDate));
    expect(prevRelevance).to.be.at.least(currentRelevance);
  }
});

Then('devo receber uma lista dos pratos ordenados pela relevância', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('devo receber uma lista dos noticias ordenadas pela popularidade', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('devo receber uma lista de conteúdos recentes', function () {
  expect(response.status).to.equal(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

Then('os conteúdos devem ser organizados por data de publicação, do mais recente para o mais antigo', function () {
  for (let i = 1; i < response.body.length; i++) {
    const prevItem = response.body[i - 1];
    const currentItem = response.body[i];
    const prevDate = new Date(prevItem.publicationDate);
    const currentDate = new Date(currentItem.publicationDate);
    expect(prevDate).to.be.at.least(currentDate);
  }
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

// Função para calcular a relevância de notícias (views / dias)
const calculateAdjustedRelevance = (views, rating, daysDifference) => {
  return daysDifference === 0 ? views * rating : (views * rating) / daysDifference;
}