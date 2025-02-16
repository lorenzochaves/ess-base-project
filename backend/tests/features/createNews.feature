Feature: Criar Notícias
    As a usuário administrador
    I want to criar e gerenciar notícias sobre o restaurante universitário
    So that eu possa informar os usuários sobre atualizações e eventos

  Scenario: Criar notícia com sucesso
    Given o usuario administrador "James" esta autenticado no sitema
    When o usuario envia uma requisição POST para "/news" com um JSON com title "RU UFPE adota medidas sustentáveis", subtitle "Restaurante universitário implementa práticas ecológicas.", body "O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização." de corpo
    Then o sistema retorna um status code "201"
    And a resposta deve conter title "RU UFPE adota medidas sustentáveis", subtitle "Restaurante universitário implementa práticas ecológicas.", body "O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização."

  Scenario: Criar notícia sem título
    Given o usuario administrador "James" esta autenticado no sitema
    When o usuario envia uma requisição POST para "/news" com um JSON com subtitle "Restaurante universitário implementa práticas ecológicas.", body "O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização." de corpo
    Then o sistema retorna um status code "400"
    And a resposta deve conter a mensagem de erro "O título é obrigatório"

  Scenario: Criar notícia com corpo acima do limite
    Given o usuario administrador "James" esta autenticado no sitema
    When o usuario envia uma requisição POST para "/news" com um JSON com title "Notícia grande", subtitle "Subtitulo da noticia grande", body "A sustentabilidade é um tema crucial nos dias de hoje. O RU UFPE está implementando práticas eco-friendly, como a redução de plásticos e a compostagem de resíduos orgânicos. Essas ações visam minimizar o impacto ambiental e promover um futuro mais verde. Vamos todos contribuir para um planeta mais saudável!", de corpo
    Then o sistema retorna um status code "400"
    And a resposta deve conter a mensagem de erro "O corpo da notícia excede o limite de 250 caracteres"

  Scenario: Editar notícia existente
    Given o usuario administrador "James" esta autenticado no sitema
    And existe uma notícia com ID "1"
    When o usuario envia uma requisição PUT para "/news/1" com um JSON com title "Novo título", subtitle "Novo subtitulo", body "Novo conteúdo atualizado" de corpo
    Then o sistema retorna um status code "201"
    And a resposta deve conter title "Novo título", subtitle "Novo subtitulo", body "Novo conteúdo atualizado"

  Scenario: Excluir notícia com sucesso
    Given o usuario administrador "James" esta autenticado no sitema
    And existe uma notícia com ID "1"
    When o usuario envia uma requisição DELETE para "news/1"
    Then o sistema retorna um status code "204"
    And a notícia não deve mais estar disponível no sistema
