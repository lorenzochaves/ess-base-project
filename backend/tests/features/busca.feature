Feature: Busca de itens no menu

  @busca
  Scenario: busca um prato pelo nome
    Given que existe um prato chamado "Bolo de Chocolate"
    When eu faço uma requisição GET para "/search?name=Bolo de Chocolate" na busca
    Then devo receber os detalhes do prato "Bolo de Chocolate"
    And o código de status das respostas deve ser 200

  @busca
  Scenario: busca um prato por categoria
    Given que existem pratos cadastrados na categoria "Italiana"
    When eu faço uma requisição GET para "/search?category=Italiana" na busca
    Then devo receber uma lista de pratos da categoria "Italiana"
    And o código de status das respostas deve ser 200

  @busca
  Scenario: busca um prato por nota mínima
    Given que existem pratos com diferentes avaliações
    When eu faço uma requisição GET para "/search?minNota=4.5" na busca
    Then devo receber apenas pratos com nota igual ou superior a 4.5
    And o código de status das respostas deve ser 200

  @busca
  Scenario: busca pratos mais vistos
    Given que existem pratos com diferentes números de visualizações
    When eu faço uma requisição GET para "/most-viewed" na busca
    Then devo receber uma lista com os 5 pratos mais vistos
    And o código de status das respostas deve ser 200

  @busca
  Scenario: Filtrar pratos utilizando múltiplos critérios
    Given que existem pratos cadastrados com categorias e avaliações diversas
    When eu faço uma requisição GET para "/search?category=Brasileira&minNota=4.5" na busca
    Then devo receber os pratos que correspondem aos critérios aplicados
    And o código de status das respostas deve ser 200

  @busca
  Scenario: Filtrar pratos sem retorno de resultados
    Given que não existem pratos cadastrados que atendam aos filtros aplicados
    When eu faço uma requisição GET para "/search?minNota=5" na busca
    Then devo receber uma mensagem "Nenhum prato encontrado com esses filtros"
    And o código de status das respostas deve ser 404

  @busca
  Scenario: Limpar filtros da busca
    Given que existem filtros aplicados na search
    When eu faço uma requisição GET para "/search" sem parâmetros
    Then devo receber todos os pratos cadastrados no sistema
    And o código de status das respostas deve ser 200
