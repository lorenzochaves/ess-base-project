const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');
const axios = require('axios');

let response;

// Passo: Fazer uma requisição POST para "/api/dishes" com os dados
When('eu faço uma requisição POST para {string} com os dados:', async function (endpoint, dataTable) {
  const data = dataTable.rowsHash(); // Converte a tabela em um objeto
  try {
    response = await axios.post(`http://localhost:3000${endpoint}`, data);
  } catch (error) {
    response = error.response;
  }
});

// Passo: Fazer uma requisição GET para "/api/dishes/{id}"
When('eu faço uma requisição GET para {string}', async function (endpoint) {
  try {
    response = await axios.get(`http://localhost:3000${endpoint}`);
  } catch (error) {
    response = error.response;
  }
});

// Passo: Verificar o código de status da resposta
Then('o código de status da resposta deve ser {int}', function (statusCode) {
  assert.strictEqual(response.status, statusCode);
});

// Passo: Verificar se a resposta contém um prato com nome específico
Then('a resposta deve conter um prato com nome {string}', function (expectedName) {
  assert.strictEqual(response.data.name, expectedName);
});

// Passo: Verificar se a resposta contém uma mensagem de erro
Then('a resposta deve conter a mensagem de erro {string}', function (errorMessage) {
  assert.strictEqual(response.data.message, errorMessage);
});

// Passo: Verificar se a resposta contém os dados do prato
Then('a resposta deve conter os dados do prato', function () {
  assert.ok(response.data.id, 'O ID do prato não foi encontrado.');
  assert.ok(response.data.name, 'O nome do prato não foi encontrado.');
  assert.ok(response.data.description, 'A descrição do prato não foi encontrada.');
  assert.ok(response.data.category, 'A categoria do prato não foi encontrada.');
  assert.ok(response.data.ingredients, 'Os ingredientes do prato não foram encontrados.');
  assert.ok(response.data.rating, 'O rating do prato não foi encontrado.');
  assert.ok(response.data.views, 'As views do prato não foram encontradas.');
});

// Passo: Verificar se a resposta contém múltiplas mensagens de erro
Then('a resposta deve conter a mensagem de erro {string} e {string}', function (error1, error2) {
  assert(response.data.message.includes(error1), `A mensagem de erro "${error1}" não foi encontrada.`);
  assert(response.data.message.includes(error2), `A mensagem de erro "${error2}" não foi encontrada.`);
});