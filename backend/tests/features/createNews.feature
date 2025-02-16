Feature: Criar Notícias
    As a usuário administrador
    I want to criar e gerenciar notícias sobre o restaurante universitário
    So that eu possa informar os usuários sobre atualizações e eventos

  Scenario: Criar notícia com sucesso
    Given o usuario administrador "James" esta autenticado no sitema
    When o usuario envia uma requisição POST para "/news" com um JSON com title "RU UFPE adota medidas sustentáveis", subtitle "Restaurante universitário implementa práticas ecológicas.", body "O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização.", publicationDate "10/02/2025" de corpo
    Then o sistema retorna um status code "201"
    And o JSON da resposta deve conter title "RU UFPE adota medidas sustentáveis", "RU UFPE adota medidas sustentáveis", subtitle "Restaurante universitário implementa práticas ecológicas.", body "O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização.", publicationDate "10/02/2025"

  Scenario: Criar notícia sem título
    Given O administrador quer publicar uma notícia
    When uma requisição POST com um JSON com body "Descrição detalhada", publish_date "2025-02-16" de corpo
    And esta requisição for enviada para "news/create"
    Then o status da resposta deve ser "400"
    And o JSON deve conter message "O título é obrigatório" e error "Bad Request"

  Scenario: Criar notícia com corpo acima do limite
    Given O administrador quer publicar uma notícia
    And o corpo da notícia contém mais de 1000 caracteres
    When uma requisição POST com um JSON com title "Notícia grande", body "<conteúdo com mais de 1000 caracteres>", publish_date "2025-02-16" de corpo
    And esta requisição for enviada para "news/create"
    Then o status da resposta deve ser "400"
    And o JSON deve conter message "O corpo da notícia excede o limite de caracteres" e error "Bad Request"

  Scenario: Editar notícia existente
    Given Existe uma notícia com ID "123"
    And O administrador quer editar a notícia
    When uma requisição PUT com um JSON com title "Novo título", body "Novo conteúdo atualizado" de corpo
    And esta requisição for enviada para "news/123"
    Then o status da resposta deve ser "200"
    And o JSON da resposta deve conter title "Novo título", body "Novo conteúdo atualizado", updated_at "<data_atualizada>"

  Scenario: Excluir notícia com sucesso
    Given Existe uma notícia com ID "456"
    And O administrador quer excluir a notícia
    When uma requisição DELETE for enviada para "news/456"
    Then o status da resposta deve ser "204"
    And a notícia não deve mais estar disponível no sistema
