// npx cucumber-js --require tests/steps_definitions tests/features/busca.feature

const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../../src/app'); // Certifique-se de ajustar o caminho para o seu app
chai.use(chaiHttp);
const expect = chai.expect;
// Criar uma nova instância do app para testes
const app = express();
app.use(express.json());
app.use('/categories', categoriesRouter);
let response;

// Serviço retorna itens que correspondem à categoria buscada
Given('existem itens cadastrados nas categorias {string} e {string}', function (categoria1, categoria2) {
  // Esse passo pode ser apenas narrativo, pois assumimos que os itens já estão cadastrados no sistema.
});

When('envio uma requisição GET para "/busca" com o parâmetro:', async function (dataTable) {
  const params = dataTable.rowsHash();
  response = await chai.request(app).get('/busca').query(params);
});

Then('o serviço retorna os itens:', function () {
  expect(response).to.have.status(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

// Serviço retorna itens filtrados por múltiplas condições
Given('o sistema possui itens cadastrados com categorias e avaliações', function () {
  // Passo narrativo, assumimos que os itens já existem.
});

Then('o serviço retorna:', function () {
  expect(response).to.have.status(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

// Serviço retorna todos os itens ao limpar os filtros
Given('existem filtros aplicados na busca', function () {
  // Passo narrativo, assumimos que o usuário aplicou filtros antes.
});

When('envio uma requisição GET para "/busca" sem parâmetros de filtro', async function () {
  response = await chai.request(app).get('/busca');
});

Then('o serviço retorna todos os itens cadastrados no sistema:', function () {
  expect(response).to.have.status(200);
  expect(response.body).to.be.an('array').that.is.not.empty;
});

// Serviço retorna itens que correspondem ao nome buscado
Given('existem itens cadastrados com o nome {string}', function (nomePrato) {
  // Passo narrativo, assumimos que os itens já existem.
});

When('envio uma requisição GET para "/busca" com o parâmetro:', async function (dataTable) {
  const params = dataTable.rowsHash();
  response = await chai.request(app).get('/busca').query(params);
});

// Serviço ignora filtros com valores inválidos
Given('o sistema possui filtros válidos para busca', function () {
  // Assumimos que os filtros são previamente definidos.
});

Then('o serviço ignora os filtros inválidos', function () {
  expect(response).to.have.status(200);
  expect(response.body).to.be.an('array');
});

Then('retorna os itens disponíveis com base nos filtros válidos restantes:', function () {
  expect(response.body).to.be.an('array').that.is.not.empty;
});

// Serviço retorna itens com múltiplos filtros simultâneos e nenhuma correspondência
Given('existem itens cadastrados com categorias e popularidade diversas', function () {
  // Passo narrativo.
});

When('envio uma requisição GET para "/busca" com os parâmetros:', async function (dataTable) {
  const params = dataTable.rowsHash();
  response = await chai.request(app).get('/busca').query(params);
});

Then('o serviço retorna a mensagem:', function (dataTable) {
  const expectedMessage = dataTable.rowsHash().mensagem;
  expect(response).to.have.status(404);
  expect(response.body).to.deep.equal({ error: expectedMessage });
});

Then('nenhum item é retornado.', function () {
  expect(response.body).to.be.empty;
});
