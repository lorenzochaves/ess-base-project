const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');

const expect = chai.expect;
let response;

Given('O administrador quer deletar um cadastro no sistema', function () {
  // Não há ações necessárias aqui, pois estamos apenas configurando o contexto
});

When('uma requisição DELETE for enviada para {string}', async function (url) {
  try {
    response = await request(app).delete(url);
  } catch (error) {
    response = error.response;
  }
});

Then('o status da resposta deve ser {string}', function (statusCode) {
  expect(response.status).to.equal(parseInt(statusCode));
});

Then('o JSON deve conter a message {string}', function (message) {
    expect(response.body.message).to.equal(message);
});