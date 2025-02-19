Feature: Página Inicial/Feed

  # Cenários de Exibição de Conteúdos na Página Inicial
  Scenario: Exibir conteúdos com base na categoria
    Given que há pratos cadastrados na categoria "pratos"
    When uma requisicao GET é feita para "/inital/feed?filter=categoria&category=pratos"
    Then devo receber uma lista dos pratos ordenados pela relevância
    And o código da resposta deve ser "200"
    And os conteúdos devem ser organizados por relevância dentro da categoria

  Scenario: Exibir conteúdos com base na categoria
    Given que existem noticias cadastradas na categoria "noticia"
    When uma requisicao GET é feita para "/inital/feed?filter=categoria&category=noticia"
    Then devo receber uma lista dos noticias ordenadas pela popularidade
    And o código da resposta deve ser "200"
    And os conteúdos devem ser organizados por popularidade dentro da categoria

  Scenario: Exibir conteúdos novos (novidades)
    Given que existem conteúdos adicionados recentemente
    When uma requisicao GET é feita para "/inital/feed?filter=novidades"
    Then devo receber uma lista de conteúdos recentes
    And o código da resposta deve ser "200"
    And os conteúdos devem ser organizados por data de publicação, do mais recente para o mais antigo