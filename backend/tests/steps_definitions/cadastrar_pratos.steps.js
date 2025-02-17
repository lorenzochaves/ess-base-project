// npm install --save-dev concurrently
// npx concurrently "npm run start" "npx cucumber-js --require tests/steps_definitions/cadastrar_pratos.steps.js tests/features/cadastrar_pratos.feature"



// npx cucumber-js --require tests/steps_definitions/cadastrar_pratos.steps.js tests/features/cadastrar_pratos.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');
const chai = require('chai');
const request = require('supertest');
const app = require('../../src/app.js');


const expect = chai.expect;
let response;

// Passo: Fazer uma requisição POST para "/api/dishes" com os dados
When('eu faço uma requisição POST para {string} com os dados:', async function (endpoint, dataTable) {
  const data = dataTable.rowsHash();
  try {
    response = await request(app).post(endpoint).send(data);
  } catch (error) {
    console.error('Erro na requisição:', error.message);
    response = error.response;
  }
});

// Passo: Fazer uma requisição GET para "/api/dishes/{id}"
When('eu faço uma requisição GET para {string}', async function (endpoint) {
  try {
    response = await request(app).get(endpoint);
  } catch (error) {
    console.error('Erro na requisição:', error.message);
    response = error.response;
  }
});

// Passo: Verificar o código de status da resposta
Then('o código de status da resposta deve ser {int}', function (statusCode) {
  assert.ok(response, 'Status Code.');
  assert.strictEqual(response.status, statusCode);
});

// Passo: Verificar se a resposta contém um prato com nome específico
Then('a resposta deve conter um prato com nome {string}', function (expectedName) {
  assert.ok(response, 'A resposta não foi definida.');
  assert.strictEqual(response.body.name, expectedName);
});

// Passo: Verificar se a resposta contém uma mensagem de erro
Then('a resposta deve conter a mensagem de erro {string}', function (errorMessage) {
  assert.ok(response, 'A resposta não foi definida.');
  assert.strictEqual(response.body.error, errorMessage);
});

// Passo: Verificar se a resposta contém os dados do prato
Then('a resposta deve conter os dados do prato', function () {
  assert.ok(response, 'A resposta não foi definida.');
  assert.ok(response.body.id, 'O ID do prato não foi encontrado.');
  assert.ok(response.body.name, 'O nome do prato não foi encontrado.');
  assert.ok(response.body.description, 'A descrição do prato não foi encontrada.');
  assert.ok(response.body.category, 'A categoria do prato não foi encontrada.');
  assert.ok(response.body.ingredients, 'Os ingredientes do prato não foram encontrados.');
  assert.ok(response.body.rating, 'O rating do prato não foi encontrado.');
  assert.ok(response.body.views, 'As views do prato não foram encontradas.');
});

// Passo: Verificar se a resposta contém múltiplas mensagens de erro
Then('a resposta deve conter a mensagem de erro {string} e {string}', function (error1, error2) {
  assert.ok(response, 'A resposta não foi definida.');
  assert(response.body.message.includes(error1), `A mensagem de erro "${error1}" não foi encontrada.`);
  assert(response.body.message.includes(error2), `A mensagem de erro "${error2}" não foi encontrada.`);
});


