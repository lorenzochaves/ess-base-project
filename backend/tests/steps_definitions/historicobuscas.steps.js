// npx cucumber-js --require tests/steps_definitions/historicobuscas.steps.js tests/features/historico-buscas.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const request = require('supertest');
const chai = require('chai');
const app = require('../../src/app.js');
const { salvarBusca, getHistorico, limparHistorico } = require('../../src/database/historicoBuscas.js');
const { dishes } = require('../../src/database/pratos.js');

const expect = chai.expect;

let response;

// Steps do Contexto
Given('que o histórico de buscas está vazio', function () {
  limparHistorico();
});

Given('que o sistema possui os seguintes pratos cadastrados:', function (dataTable) {
  const pratosCadastrados = dataTable.hashes().map(prato => ({
    name: prato.nome,
    category: prato.categoria,
    rating: parseFloat(prato.nota),
    views: parseInt(prato.visualizacoes),
    description: prato.descricao
  }));

});

// Steps de Histórico
Given('que o histórico contém {int} buscas antigas', function (quantidade) {
  limparHistorico();
  for (let i = 0; i < quantidade; i++) {
    salvarBusca(`Busca${i}`, {});
  }
});

Given('que o histórico de buscas contém as seguintes buscas:', function (dataTable) {
  limparHistorico();
  const buscas = dataTable.hashes();
  for (let i = buscas.length - 1; i >= 0; i--) {
    const busca = buscas[i];
    salvarBusca(busca.termo, JSON.parse(busca.filtros || '{}'));
  }
});

// Steps de Requisição
When('o usuário faz uma requisição GET para {string}', async function (endpoint) {
  response = await request(app).get(endpoint);
});

When('o usuário faz uma requisição DELETE para {string}', async function (endpoint) {
  response = await request(app).delete(endpoint);
});

// Steps de Verificação de Resposta
Then('a resposta deve ser {string}', function (statusCode) { 
  expect(response.status).to.equal(parseInt(statusCode));
});

Then('a resposta deve conter {int} prato(s)', function (quantidade) {
  expect(response.body).to.be.an('array');
  expect(response.body).to.have.lengthOf(quantidade);
});

Then('o prato deve ter nome {string}', function (nome) {
  const prato = response.body[0];
  expect(prato.name).to.equal(nome);
});

Then('os pratos devem ser da categoria {string}', function (categoria) {
  response.body.forEach(prato => {
    expect(prato.category).to.equal(categoria);
  });
});

Then('todos os pratos devem ter nota maior ou igual a {float}', function (nota) {
  response.body.forEach(prato => {
    expect(prato.rating).to.be.at.least(nota);
  });
});

Then('todos os pratos devem ter nota entre {float} e {float}', function (min, max) {
  response.body.forEach(prato => {
    expect(prato.rating).to.be.at.least(min);
    expect(prato.rating).to.be.at.most(max);
  });
});

Then('todos os pratos devem ter mais de {int} visualizações', function (views) {
  response.body.forEach(prato => {
    expect(prato.views).to.be.at.least(views);
  });
});

Then('os pratos devem ter {string} no nome', function (termo) {
  response.body.forEach(prato => {
    expect(prato.name.toLowerCase()).to.include(termo.toLowerCase());
  });
});

Then('os pratos devem atender a todos os critérios', function () {
  response.body.forEach(prato => {
    expect(prato.category).to.equal('Italiana');
    expect(prato.rating).to.be.at.least(4.3);
    expect(prato.views).to.be.at.most(400);
  });
});

Then('a mensagem de erro será {string}', function (mensagem) {
  expect(response.body.error).to.equal(mensagem);
});

Then('o histórico deve conter exatamente {int} buscas', function (quantidade) {
  expect(getHistorico()).to.have.lengthOf(quantidade);
});

Then('a busca mais recente deve ter termo {string}', function (termo) {
  expect(getHistorico()[0].termo).to.equal(termo);
});

Then('o corpo da resposta deve ser um array vazio', function () {
  expect(response.body).to.be.an('array').that.is.empty;
});

// Steps de Verificação de Histórico
Then('o histórico de buscas deve conter as seguintes buscas:', function (dataTable) {
  const historicoEsperado = dataTable.hashes().map(busca => ({
    termo: busca.termo,
    filtros: JSON.parse(busca.filtros || '{}'),
  }));

  const historicoAtual = getHistorico();
  
  expect(historicoAtual.length).to.equal(historicoEsperado.length, 'Número de buscas no histórico diferente do esperado');
  
  historicoAtual.forEach((busca, index) => {
    expect(busca.termo).to.equal(historicoEsperado[index].termo, `Termo incorreto na posição ${index}`);
    expect(busca.filtros).to.deep.equal(historicoEsperado[index].filtros, `Filtros incorretos na posição ${index}`);
  });
});

Then('o histórico de buscas deve estar vazio', function () {
  expect(getHistorico()).to.be.an('array').that.is.empty;
});

Then('o prato retornado deve corresponder aos dados cadastrados', function () {
  const prato = response.body[0];
  const pratoOriginal = dishes.find(d => d.name === prato.name);
  expect(pratoOriginal).to.not.be.undefined;
  expect(prato.category).to.equal(pratoOriginal.category);
  expect(prato.rating).to.equal(pratoOriginal.rating);
  expect(prato.description).to.equal(pratoOriginal.description);
});