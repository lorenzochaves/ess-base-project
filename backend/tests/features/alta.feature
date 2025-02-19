Feature: Seção "Em Alta"

  # Cenários de Exibição de Conteúdos
  Scenario: Exibir lista de noticias em alta
    Given que existem noticias populares nas categorias "noticias"
    When faço uma requisição GET para "/trending/em-alta?type=noticias"
    Then devo receber uma lista das noticias em alta
    And o código de status da resposta deve ser "200"
    And os conteúdos devem ser organizados por popularidade, com base nas visualizações recentes

  Scenario: Exibir lista de pratos em alta
    Given que existem pratos populares na categoria "pratos"
    When faço uma requisição GET para "/trending/em-alta?type=pratos"
    Then devo receber uma lista dos pratos em alta
    And o código de status da resposta deve ser "200"
    And os conteúdos devem ser organizados por popularidade, com base nas visualizações recentes

  Scenario: Exibir lista de pratos em alta por categoria
    Given que existem itens populares na categoria "Italiana"
    When faço uma requisição GET para "/trending/em-alta?category=Italiana"
    Then devo receber uma lista das noticias em alta
    And o código de status da resposta deve ser "200"
    And os conteúdos devem ser organizados por popularidade, com base nas visualizações recentes

  Scenario: Exibir conteúdos populares entre todos os usuários
    Given que existem conteúdos com alta visualização e interação de todos os usuários nas categorias "pratos" e "noticias"
    When faço uma requisição GET para "/trending/em-alta"
    Then devo receber os conteúdos mais populares entre todos os usuários
    And o código de status da resposta deve ser "200"
    And os conteúdos devem ser organizados por popularidade, com base nas visualizações recentes