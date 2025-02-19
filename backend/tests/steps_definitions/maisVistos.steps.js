// npx cucumber-js --require tests/steps_definitions tests/features/maisVistos.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');
const request = require('supertest');
const app = require('../../src/app.js'); // Ajuste o caminho conforme necessário

let response;
let pratosCadastrados = [];

// Contexto inicial
Given('que o sistema possui os seguintes pratos cadastrados maisVistos:', { tags: '@maisVisto' }, function (dataTable) {
  pratosCadastrados = dataTable.hashes().map(prato => ({
    name: prato.nome,
    category: prato.categoria,
    rating: parseFloat(prato.nota),
    views: parseInt(prato.visualizacoes),
    description: prato.descricao
  }));
});

// Steps de Requisição
When('o usuário faz uma requisição GET para {string} maisVisto', { tags: '@maisVisto' }, async function (endpoint) {
  response = await request(app).get(endpoint);
});

// Steps de Verificação de Resposta
Then('a resposta deve ser {string} maisVisto', { tags: '@maisVisto' }, function (statusCode) {
  expect(response.status).to.equal(parseInt(statusCode));
});

Then('a resposta deve conter os pratos ordenados por visualizações em ordem decrescente:', { tags: '@maisVisto' }, function (dataTable) {
    let expectedPratos = dataTable.hashes().map(prato => ({
        nome: prato.nome,
        visualizacoes: parseInt(prato.visualizacoes)
    }));

    // Apenas os 5 primeiros pratos esperados
    expectedPratos = expectedPratos.slice(0, 5);

    const obtainedPratos = response.body.map(prato => ({
        nome: prato.name,
        visualizacoes: prato.views
    }));

    //console.log("🔍 Esperado:", JSON.stringify(expectedPratos, null, 2));
    //console.log("🚀 Obtido:", JSON.stringify(obtainedPratos, null, 2));

    expect(obtainedPratos).to.deep.equal(expectedPratos);
});


// Cenário: Listar os pratos mais vistos após remover um prato
Given('que o prato {string} foi removido do sistema', { tags: '@maisVisto' }, async function (nomePrato) {
  // Buscar o ID do prato pelo nome
  const response = await request(app).get('/dishes');
  expect(response.status).to.equal(200);

  const prato = response.body.find(p => p.name === nomePrato);
  if (!prato) {
      throw new Error(`Prato "${nomePrato}" não encontrado no sistema`);
  }

  // Fazer a requisição DELETE usando o ID
  const deleteResponse = await request(app).delete(`/dishes/${prato.id}`);
  expect(deleteResponse.status).to.equal(204);
});

Given('que o prato {string} foi adicionado ao sistema com {int} visualizações', { tags: '@maisVisto' }, async function (nomePrato, visualizacoes) {
    const newDish = {
        name: nomePrato,
        description: 'Descrição do novo prato',
        category: 'Italiana',
        ingredients: ['ingrediente1', 'ingrediente2'],
        views: visualizacoes // Passa o número de visualizações customizado
    };

    const response = await request(app)
        .post('/dishes')
        .send(newDish);

    expect(response.status).to.equal(201);
});

// Cenário: Listar os pratos mais vistos sem pratos cadastrados
let backupPratos = []; // Variável global para armazenar o dataset original

// Cenário: Listar os pratos mais vistos sem pratos cadastrados
Given('que não há pratos cadastrados no sistema', { tags: '@maisVisto' }, async function () {
    // Faz backup do dataset atual antes de limpar
    const response = await request(app).get('/dishes');
    backupPratos = response.body; // Armazena os pratos antes de deletar

    // Deleta cada prato do sistema
    for (const prato of backupPratos) {
        await request(app).delete(`/dishes/${prato.id}`);
    }
});

Then('a resposta deve conter uma lista vazia', { tags: '@maisVisto' }, async function () {
    expect(response.body).to.be.an('array').that.is.empty;

    // Restaura os pratos deletados
    for (const prato of backupPratos) {
        await request(app)
            .post('/dishes')
            .send({
                name: prato.name,
                description: prato.description,
                categoryName: prato.category,
                ingredients: prato.ingredients || [],
                rating: prato.rating || [],
                views: prato.views, // Mantém o número de visualizações original
            });
    }
});
